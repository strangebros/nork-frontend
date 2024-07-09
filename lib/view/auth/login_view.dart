import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nork/service/auth_service.dart';
import 'package:nork/component/text_field.dart';
import 'package:nork/view/auth/signup_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController pwController = TextEditingController();

    FocusNode idFocusNode = FocusNode();
    FocusNode pwFocusNode = FocusNode();

    return GestureDetector(
      onTap: () {
        idFocusNode.unfocus();
        pwFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff2a2a2a),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
            child: Column(
              children: [
                Spacer(),
                Image.asset(
                  "assets/images/main_logo.png",
                  width: 30.w,
                  fit: BoxFit.cover,
                ),
                Spacer(),
                NorkTextField.build(
                    backgroundColor: Color.fromARGB(255, 73, 73, 73),
                    controller: idController,
                    focusNode: idFocusNode,
                    cursorColor: Colors.white,
                    enabled: true,
                    fontSize: 10.sp,
                    hintText: "아이디",
                    obscureText: false,
                    textColor: Colors.white),
                SizedBox(height: 1.h),
                NorkTextField.build(
                    backgroundColor: Color.fromARGB(255, 73, 73, 73),
                    controller: pwController,
                    focusNode: pwFocusNode,
                    cursorColor: Colors.white,
                    enabled: true,
                    fontSize: 10.sp,
                    hintText: "비밀번호",
                    obscureText: true,
                    textColor: Colors.white),
                SizedBox(height: 1.h),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    bool result =
                        await Provider.of<AuthService>(context, listen: false)
                            .login(
                                email: idController.text,
                                password: pwController.text);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('로그인에 성공했습니다.'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: const Color.fromARGB(255, 82, 114, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    child: SizedBox(
                      height: 5.5.h,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "로그인",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(context).push(SwipeablePageRoute(
                          builder: (BuildContext context) => const SignupView(),
                        ));
                      },
                      child: Text(
                        "새로운 계정 만들기",
                        style: TextStyle(color: Colors.white, fontSize: 9.sp),
                      ),
                    ),
                    SizedBox(
                      height: 1.25.h,
                      width: 10.w,
                      child: const VerticalDivider(
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        "비밀번호를 잊으셨나요?",
                        style: TextStyle(color: Colors.white, fontSize: 9.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
