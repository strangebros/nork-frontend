import 'package:dio/dio.dart';
import 'package:synchronized/extension.dart';
import 'package:nork/service/auth_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioInstance {
  final SharedPreferences prefs;
  final AuthService authService;

  final _secureStorage = const FlutterSecureStorage();
  static Dio? _dio;

  DioInstance({required this.prefs, required this.authService}) {
    _dio = _buildDio();
  }

  static Dio get dio {
    if (_dio == null) {
      throw StateError("아직 dio instance가 초기화되지 않았습니다.");
    }
    return _dio!;
  }

  Dio _buildDio() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost:8080', // 기본 URL 설정
    );

    Dio dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 인터셉터를 제외할 URL 설정
        const excludedUrls = ['/members/signUp', '/members/login'];

        // 현재 요청 URL이 제외할 URL 목록에 있는지 확인
        if (excludedUrls.contains(options.path)) {
          return handler.next(options);
        }

        return synchronized(() async {
          bool? isLogined = prefs.getBool("isLogined");
          String? accessToken = await _secureStorage.read(key: "accessToken");

          if (isLogined == null || !isLogined || accessToken == null) {
            // 로그인 필요
            return handler.reject(
                DioException(requestOptions: options, message: "로그인이 필요합니다."));
          }

          if (isTokenNeedToRefresh(accessToken)) {
            // 토큰 갱신 수행
            Response response = await dio.post("/members/refresh-token",
                data: {accessToken: accessToken});

            if (response.data["status"] == 200) {
              await _secureStorage.write(
                  key: "accessToken",
                  value: response.data["data"]["accessToken"]);
              accessToken = response.data["data"]["accessToken"];
            } else {
              await _secureStorage.deleteAll();
              await prefs.clear();
              authService.notify();

              return handler.reject(DioException(
                  requestOptions: options, message: "토큰 갱신에 실패했습니다."));
            }
          }

          // 요청 시 토큰을 함께 보내도록 설정
          options.headers["Authorization"] = "Bearer $accessToken";
          return handler.next(options); // 요청을 계속 진행
        });
      },
      onError: (DioException e, handler) async {
        // 인증 오류가 발생한 경우 로그아웃 처리
        if (e.response!.statusCode == 401) {
          await _secureStorage.deleteAll();
          await prefs.clear();
          authService.notify();
        }
      },
    ));

    return dio;
  }

  bool isTokenNeedToRefresh(String token) {
    try {
      final jwt = JWT.decode(token);
      final exp = jwt.payload['exp'];

      if (exp != null) {
        DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

        // 유효기간에 10분 패딩을 추가
        expiryDate = expiryDate.add(const Duration(minutes: 10));

        // 조정된 유효기간과 현재 시간과 비교
        final currentDate = DateTime.now();

        if (currentDate.isAfter(expiryDate)) {
          return false;
        } else {
          return true;
        }
      } else {
        throw Exception("토큰이 유효하지 않습니다.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
