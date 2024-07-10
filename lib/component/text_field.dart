import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class NorkTextField {
  static Widget build({
    required Color backgroundColor,
    required Color textColor,
    required Color cursorColor,
    required bool obscureText,
    required bool enabled,
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required double fontSize,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.1.h),
        child: TextField(
          obscureText: obscureText,
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          cursorColor: cursorColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: fontSize, color: cursorColor),
          ),
          style: TextStyle(height: 1.0, fontSize: fontSize, color: cursorColor),
        ),
      ),
    );
  }
}
