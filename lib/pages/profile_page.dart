import 'package:flutter/material.dart';
import '../storage/auth_storage.dart';
import '../storage/favorite_storage.dart';
import 'login_page.dart';
import 'notification_lbs_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = 'Memuat...';
  int _libraryCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final email = await AuthStorage.getEmail();
    final count = FavoriteStorage.getBox().length;
    if (mounted) {
      setState(() {
        _email = email ?? 'user@gmail.com';
        _libraryCount = count;
      });
    }
  }

  void _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Hapus session dari SharedPreferences
    await AuthStorage.clearSession();

    if (!mounted) return;

    // Kembali ke Login Page dan bersihkan stack navigasi
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            // 1. Avatar Icon Tengah (Sesuai Mockup)
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2C2C2C),
              child: Icon(Icons.person, size: 60, color: Colors.white54),
            ),
            const SizedBox(height: 36),

            // 2. Info Baris: Email & Games Dimiliki (Sesuai Mockup Soal SI-B)
            _buildProfileRow('Username: ', _email),
            const SizedBox(height: 16),
            _buildProfileRow('Anime Favorit:', '$_libraryCount'),

            const SizedBox(height: 36),

            // 3. Tombol Logout (Merah Sesuai Mockup Soal SI-B)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------------------
            // [FITUR BONUS LBS & NOTIFIKASI] (Poin Tambahan Sesuai Aturan Responsi)
            // -----------------------------------------------------------------
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.hub_outlined,
                  color: Color(0xFF2196F3),
                ),
                title: const Text(
                  'Fitur Tambahan (Bonus LBS & Notifikasi)',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationLbsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
