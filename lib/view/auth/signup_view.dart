import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nork/service/auth_service.dart';
import 'package:nork/component/text_field.dart';
import 'package:email_validator/email_validator.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  FocusNode idFocusNode = FocusNode();
  FocusNode pwFocusNode = FocusNode();
  FocusNode pwCheckFocusNode = FocusNode();
  FocusNode nicknameFocusNode = FocusNode();

  // position selection
  int selectedPositionIndex = -1;
  List<String> positions = ["개발자", "디자이너", "기획자", "기타"];

  // birthdate
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        idFocusNode.unfocus();
        pwFocusNode.unfocus();
        pwCheckFocusNode.unfocus();
        nicknameFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff2a2a2a),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xff2a2a2a),
          title: Text(
            "회원가입",
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
                    child: Text(
                      "아이디",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
                    child: Text(
                      "비밀번호",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                  NorkTextField.build(
                      backgroundColor: Color.fromARGB(255, 73, 73, 73),
                      controller: pwCheckController,
                      focusNode: pwCheckFocusNode,
                      cursorColor: Colors.white,
                      enabled: true,
                      fontSize: 10.sp,
                      hintText: "비밀번호 확인",
                      obscureText: true,
                      textColor: Colors.white),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
                    child: Text(
                      "닉네임",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  NorkTextField.build(
                      backgroundColor: Color.fromARGB(255, 73, 73, 73),
                      controller: nicknameController,
                      focusNode: nicknameFocusNode,
                      cursorColor: Colors.white,
                      enabled: true,
                      fontSize: 10.sp,
                      hintText: "닉네임",
                      obscureText: false,
                      textColor: Colors.white),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
                    child: Text(
                      "포지션",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5.6.h,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: positions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                              color: index == selectedPositionIndex
                                  ? const Color.fromARGB(255, 82, 114, 255)
                                  : const Color.fromARGB(255, 73, 73, 73),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  setState(() {
                                    if (selectedPositionIndex == index) {
                                      selectedPositionIndex = -1;
                                    } else {
                                      selectedPositionIndex = index;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.5.w, vertical: 1.3.h),
                                  child: Text(
                                    positions[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            index == selectedPositionIndex
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                ),
                              ));
                        }),
                  ),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
                    child: Text(
                      "생년월일",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      birthDate = await showDatePicker(
                          context: context,
                          cancelText: "취소",
                          confirmText: "선택",
                          errorFormatText: "잘못된 형식입니다.",
                          fieldHintText: "yyyy. m. dd.",
                          fieldLabelText: "직접 입력",
                          errorInvalidText: "잘못된 날짜를 입력했습니다.",
                          helpText: "생년월일 선택",
                          currentDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(DateTime.now().year));
                      setState(() {});
                    },
                    child: NorkTextField.build(
                        backgroundColor: Color.fromARGB(255, 73, 73, 73),
                        controller: TextEditingController(
                            text: birthDate == null
                                ? null
                                : "${birthDate!.year}년 ${birthDate!.month}월 ${birthDate!.day}일"),
                        focusNode: FocusNode(),
                        cursorColor: Colors.white,
                        enabled: false,
                        fontSize: 10.sp,
                        hintText: "생년월일 입력",
                        obscureText: false,
                        textColor: Colors.white),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Text("회원가입 진행 시 이용약관 및 개인정보처리방침에 동의한 것으로 간주됩니다.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                        )),
                  ),
                  SizedBox(height: 0.5.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // 필수 값 입력 여부 확인
                      if (idController.text == "" ||
                          pwController.text == "" ||
                          nicknameController.text == "" ||
                          selectedPositionIndex == -1 ||
                          birthDate == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('입력하지 않은 값이 있습니다!'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      // 값 유효성 검증
                      if (!EmailValidator.validate(idController.text)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('이메일 형식이 올바르지 않습니다!'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      if (pwController.text != pwCheckController.text) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('비밀번호가 일치하지 않습니다!'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      Provider.of<AuthService>(context, listen: false).signup(
                          context: context,
                          email: idController.text,
                          password: pwController.text,
                          nickname: nicknameController.text,
                          position: positions[selectedPositionIndex],
                          birthdate: birthDate.toString().split(" ")[0]);
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
                              "회원가입 진행",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
