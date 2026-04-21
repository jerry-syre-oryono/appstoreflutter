import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class DownloadService {
  static Future<String> downloadApk(String url, Function(double) onProgress) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/app_${DateTime.now().millisecondsSinceEpoch}.apk';
    await Dio().download(url, path, onReceiveProgress: (received, total) {
      if (total != -1) onProgress(received / total);
    });
    return path;
  }

  static void installApk(String path) {
    OpenFilex.open(path);
  }
}
