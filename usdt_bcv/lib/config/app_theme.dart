import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF49149F);

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0});

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true, 
      colorSchemeSeed: _customColor,
      brightness: Brightness.dark,
    );
  }

  static Color get primaryColor {
    return _customColor;
  }
}
