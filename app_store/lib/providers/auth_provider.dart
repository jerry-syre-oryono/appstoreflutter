import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == 'admin';

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userJson = prefs.getString('user');
    if (token != null && userJson != null) {
      ApiService.setToken(token);
      _user = UserModel.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.post('/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data;
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);
      await _saveAuthData(token, user);
      _user = user;
      ApiService.setToken(token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      final data = response.data;
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);
      await _saveAuthData(token, user);
      _user = user;
      ApiService.setToken(token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.post('/logout');
    } catch (e) {
      // ignore
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
    _user = null;
    notifyListeners();
  }

  Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
}
