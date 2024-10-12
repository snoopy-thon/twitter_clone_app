import 'package:flutter/material.dart';
import 'package:twitter_clone_app/themes/dark_mode.dart';
import 'package:twitter_clone_app/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  // initially, set it as light mode
  ThemeData _themeData = lightMode;

  // get the current theme
  ThemeData get themeData => _themeData;

  // is it dark mode currently?
  bool get isDarkMode => _themeData == darkMode;

  // set the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // update UI
    notifyListeners();
  }

  // toggle between dark & light mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
