import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nork/view/home/home_view.dart';
import 'package:nork/module/dio_instance.dart';
import 'package:nork/view/auth/login_view.dart';
import 'package:nork/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatefulWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // 지원하는 로케일 목록
          supportedLocales: const [
            Locale('en', ''), // 영어
            Locale('ko', ''), // 한국어
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('ko'), // 앱의 기본 로케일을 한국어로 설정
          builder: (context, child) {
            final scale = MediaQuery.of(context)
                .textScaler
                .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: scale),
                child: child!);
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 82, 114, 255)),
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.dark,
          home: FutureBuilder<bool>(
              future: Provider.of<AuthService>(context).isLogined(),
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
      },
    );
  }
}
