import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/app_model.dart';

class AppsProvider extends ChangeNotifier {
  List<AppModel> _apps = [];
  bool _isLoading = false;

  List<AppModel> get apps => _apps;
  bool get isLoading => _isLoading;

  Future<void> fetchApps() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/apps');
      final List<dynamic> data = response.data;
      _apps = data.map((json) => AppModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching apps: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
