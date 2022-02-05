import 'package:enough_mail_app/models/settings.dart';
import 'package:enough_mail_app/models/theme_settings.dart';
import 'package:flutter/material.dart';

class ThemeService with ChangeNotifier {
  late ThemeSettings _themeSettings;
  static final ThemeData defaultLightTheme = ThemeData(
    colorSchemeSeed: Colors.green,
    useMaterial3: true,
  );
  static final ThemeData defaultDarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.green,
    useMaterial3: true,
  );
  ThemeData _lightTheme = defaultLightTheme;
  ThemeData get lightTheme => _lightTheme;
  ThemeData _darkTheme = defaultDarkTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  Color _colorSchemeSeed = Colors.green;

  Brightness brightness(BuildContext context) {
    final mode = _themeSettings.getCurrentThemeMode();
    switch (mode) {
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context);
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }

  void init(Settings settings) {
    _themeSettings = settings.themeSettings;
    checkForChangedTheme();
  }

  void checkForChangedTheme() {
    ThemeData generateTheme(Brightness brightness, Color color) {
      if (color is MaterialColor) {
        return ThemeData(
            brightness: brightness, primarySwatch: color, useMaterial3: false);
      } else {
        return ThemeData(
            brightness: brightness, colorSchemeSeed: color, useMaterial3: true);
      }
    }

    var isChanged = false;
    final mode = _themeSettings.getCurrentThemeMode();
    if (mode != _themeMode) {
      _themeMode = mode;
      isChanged = true;
    }
    final colorSchemeSeed = _themeSettings.colorSchemeSeed;
    if (colorSchemeSeed != _colorSchemeSeed) {
      _colorSchemeSeed = colorSchemeSeed;
      _lightTheme = generateTheme(Brightness.light, colorSchemeSeed);
      _darkTheme = generateTheme(Brightness.dark, colorSchemeSeed);
      isChanged = true;
    }
    if (isChanged) {
      notifyListeners();
    }
  }
}
