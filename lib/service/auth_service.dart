import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nork/module/dio_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final SharedPreferences prefs;

  final secureStorage = const FlutterSecureStorage();

  AuthService({required this.prefs});

  void notify() {
    notifyListeners();
  }

  Future<bool> isLogined() async {
    return prefs.getBool("isLogined") == null
        ? false
        : prefs.getBool("isLogined")!;
  }

  Future<bool> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    Response response;
    try {
      response = await DioInstance.instance!.dio
          .post("/members/login", data: {"email": email, "password": password});
    } on DioException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
        duration: Duration(seconds: 2),
      ));
      return false;
    }

    // 성공 시 token 저장
    await secureStorage.write(
        key: "accessToken", value: response.data["data"]["accessToken"]);
    await prefs.setBool("isLogined", true);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('로그인에 성공했습니다.'),
      duration: Duration(seconds: 2),
    ));

    notifyListeners();
    return true;
  }

  Future<bool> signup(
      {required BuildContext context,
      required String email,
      required String password,
      required String nickname,
      required String position,
      required String birthdate}) async {
    Response response;
    try {
      response = await DioInstance.instance!.dio.post("/members/signUp", data: {
        "email": email,
        "password": password,
        "nickname": nickname,
        "position": position,
        "birthdate": birthdate,
        "profileImage": "",
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('회원가입에 실패했습니다. 오류가 계속될 경우 문의를 남겨주세요.'),
        duration: Duration(seconds: 2),
      ));
      return false;
    }

    // 성공 시 token 저장
    await secureStorage.write(
        key: "accessToken", value: response.data["data"]["accessToken"]);
    await prefs.setBool("isLogined", true);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('회원가입을 완료했습니다.'),
      duration: Duration(seconds: 2),
    ));

    notifyListeners();
    return true;
  }

  Future<bool> logout({required BuildContext context}) async {
    await secureStorage.deleteAll();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('정상적으로 로그아웃 되었습니다.'),
      duration: Duration(seconds: 2),
    ));

    notifyListeners();
    return true;
  }
}
