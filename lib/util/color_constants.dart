import 'package:flutter/material.dart';

class AppColor {
  static Color primaryGradiantStart = const Color(0xFFFF4433);
  static Color primaryGradiantEnd = const Color(0xFFFFBF00);
  static Color secondaryGradiantStart = const Color(0xFFFFF3F2);
  static Color secondaryGradiantEnd = const Color(0xFFFFF8DC);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color greyColor = const Color(0x50F3F3F3);
  static Color textGreyColor = const Color(0x30000000);
  static Color primaryColorShade = const Color(0x11FFC700);
  static Color errorColor = Colors.red;
  static Color labelColor = Colors.red.withOpacity(0.8);

  static LinearGradient appMainGradient = LinearGradient(colors: [
    AppColor.primaryGradiantStart,
    AppColor.primaryGradiantEnd,
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static LinearGradient appBarGradient = LinearGradient(colors: [
    AppColor.primaryGradiantStart,
    AppColor.primaryGradiantEnd,
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);
  static LinearGradient drawerGradient = LinearGradient(colors: [
    AppColor.primaryGradiantStart,
    AppColor.primaryGradiantEnd,
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  static LinearGradient boxGradient = LinearGradient(colors: [
    AppColor.primaryGradiantStart,
    AppColor.primaryGradiantEnd,
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);
}
