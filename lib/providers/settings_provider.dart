import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isHindi = false;
  bool get isHindi => _isHindi;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isHindi = prefs.getBool('isHindi') ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isHindi = !_isHindi;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHindi', _isHindi);
    notifyListeners();
  }
}
