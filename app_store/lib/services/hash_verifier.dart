import 'dart:io';
import 'package:crypto/crypto.dart';

class HashVerifier {
  static Future<bool> verify(String filePath, String expectedHash) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString() == expectedHash;
  }
}
