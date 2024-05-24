import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  String _token = '';
  bool _isAuthenticated = false;

  String get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  AuthState() {
    loadToken();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _isAuthenticated = _token.isNotEmpty;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = '';
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> logout() async {
    await clearToken();
  }
}
