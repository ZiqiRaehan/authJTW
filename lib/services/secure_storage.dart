import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // Simpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Hapus token
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
