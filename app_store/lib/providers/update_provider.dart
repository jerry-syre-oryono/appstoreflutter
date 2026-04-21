import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';
import '../services/hash_verifier.dart';

class UpdateProvider extends ChangeNotifier {
  final bool _isChecking = false;
  bool get isChecking => _isChecking;

  Future<Map<String, dynamic>?> checkUpdate(String package, int currentVersion) async {
    try {
      final response = await ApiService.get('/apps/check-update', queryParams: {
        'package': package,
        'version_code': currentVersion,
      });
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadAndInstall(
    BuildContext context,
    String url,
    String expectedHash,
    bool isForce,
    Function(double) onProgress,
  ) async {
    final path = await DownloadService.downloadApk(url, onProgress);
    final isValid = await HashVerifier.verify(path, expectedHash);
    if (!isValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download corrupted. Please try again.')),
        );
      }
      return;
    }
    DownloadService.installApk(path);
  }
}
