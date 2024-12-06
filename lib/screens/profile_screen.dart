import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({required this.token, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  bool isLoading = true; // Indikator loading

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  // Fungsi untuk mendapatkan data profil
  Future<void> getUserProfile() async {
    setState(() {
      isLoading = true; // Tampilkan loading
    });

    try {
      final response = await ApiService.getUserProfile(widget.token);
      setState(() {
        name = response['name'];
        email = response['email'];
        isLoading = false; // Sembunyikan loading
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Sembunyikan loading jika terjadi error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat profil')),
      );
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    setState(() {
      isLoading = true; // Tampilkan loading saat logout
    });

    try {
      // Panggil API logout
      await ApiService.logout(widget.token);
      // Hapus token dari Secure Storage
      await SecureStorage.clearToken();
      // Arahkan pengguna ke halaman login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Menghapus semua halaman sebelumnya dari stack
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Sembunyikan loading jika terjadi error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 50,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: email,
                    ),
                    const Divider(color: Colors.white24),
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: 'Nama',
                      value: name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                onPressed: logout,
                text: 'Logout',
              ),
            ],
          );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
