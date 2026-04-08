import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isHindi = false;
  bool _isDemoMode = false;
  
  bool get isHindi => _isHindi;
  bool get isDemoMode => _isDemoMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isHindi = prefs.getBool('isHindi') ?? false;
    _isDemoMode = prefs.getBool('isDemoMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isHindi = !_isHindi;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHindi', _isHindi);
    notifyListeners();
  }

  Future<void> toggleDemoMode() async {
    _isDemoMode = !_isDemoMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDemoMode', _isDemoMode);
    notifyListeners();
  }
}
