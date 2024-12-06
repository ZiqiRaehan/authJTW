import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Fungsi Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Fungsi Register
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }), // Pastikan key sesuai dengan yang dibutuhkan backend
    );
    return jsonDecode(response.body);
  }

  // Fungsi Get User Profile
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Fungsi Get Online Users (Baru)
  static Future<List<Map<String, dynamic>>> getOnlineUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/online-users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (data['users'] != null) {
      return List<Map<String, dynamic>>.from(data['users']);
    } else {
      throw Exception('Tidak ada data pengguna.');
    }
  }

  static Future<void> logout(String token) async {
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  static Future<List<Map<String, dynamic>>> getAllUsers(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/all-users'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['users']);
  } else {
    throw Exception('Gagal mengambil data pengguna');
  }
}

}
