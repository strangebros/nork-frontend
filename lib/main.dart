import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nork/view/home/home_view.dart';
import 'package:nork/module/dio_instance.dart';
import 'package:nork/view/auth/login_view.dart';
import 'package:nork/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // dio instance init
  AuthService authService = AuthService(prefs: prefs);
  DioInstance(prefs: prefs, authService: authService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authService),
      ],
      child: MyApp(authService: authService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final scale = MediaQuery.of(context)
            .textScaler
            .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scale),
            child: child!);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
          future: authService.isLogined(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // 로그인 정보 로딩
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: LoadingAnimationWidget.prograssiveDots(
                        color: Colors.black, size: 10.w)),
              );
            }

            // 로그인 여부에 따른 초기 페이지 분기
            return snapshot.data! ? const HomeView() : const LoginView();
          }),
    );
  }
}
