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

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    Response response;
    try {
      response = await DioInstance.instance!.dio
          .post("/members/login", data: {"email": email, "password": password});
    } on DioException catch (_) {
      return false;
    }

    // 성공 시 token 저장
    await secureStorage.write(
        key: "accessToken", value: response.data["data"]["accessToken"]);
    await prefs.setBool("isLogined", true);

    notifyListeners();
    return true;
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String nickname,
    required String position,
    required String birthdate,
  }) async {
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
      return false;
    }

    // 성공 시 token 저장
    await secureStorage.write(
        key: "accessToken", value: response.data["data"]["accessToken"]);
    await prefs.setBool("isLogined", true);

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
