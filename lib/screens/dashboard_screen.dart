import 'package:flutter/material.dart';
import '../screens/online_users_tab.dart';
import '../screens/profile_screen.dart';
import '../services/secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  String? token;

  final List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    initializeToken();
  }

  Future<void> initializeToken() async {
    final storedToken = await SecureStorage.getToken();
    setState(() {
      token = storedToken;
      tabs.add(const OnlineUsersTab());
      tabs.add(ProfileScreen(token: token!)); // Kirim token ke ProfileScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF17153F),
              Color(0xFF242266),
            ],
          ),
        ),
        child: SafeArea(
          child: DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      indicator: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.people),
                              const SizedBox(width: 8),
                              Text('Online Users', style: GoogleFonts.poppins()),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 8),
                              Text('Profile', style: GoogleFonts.poppins()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: currentIndex,
                    children: tabs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
