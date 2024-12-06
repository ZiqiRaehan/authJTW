import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineUsersTab extends StatefulWidget {
  const OnlineUsersTab({super.key});

  @override
  State<OnlineUsersTab> createState() => _OnlineUsersTabState();
}

class _OnlineUsersTabState extends State<OnlineUsersTab> {
  late Future<List<Map<String, dynamic>>> allUsersFuture;

  @override
  void initState() {
    super.initState();
    allUsersFuture =
        fetchAllUsers(); // Pastikan allUsersFuture diinisialisasi di sini
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final token = await SecureStorage.getToken();
      if (token != null) {
        return await ApiService.getAllUsers(token);
      } else {
        throw Exception('Token tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: allUsersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.withOpacity(0.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat data pengguna',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final allUsers = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: allUsers.length,
            itemBuilder: (context, index) {
              final user = allUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: user['isOnline'] 
                            ? const Color(0xFF6C63FF)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  title: Text(
                    user['name'] ?? 'No Name',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    user['email'] ?? 'No Email',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: user['isOnline'] ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 60,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada pengguna',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
