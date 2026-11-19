import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// [STORAGE AUTHENTICATION] - Menggunakan SharedPreferences (Modul 6)
/// ============================================================================
/// Berfungsi untuk menyimpan session login aktif user serta data akun jika
/// soal responsi membutuhkan fitur Register/Login berbasis local storage.
/// ============================================================================

class AuthStorage {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyEmail = 'email';

  // Key untuk opsi jika menggunakan Register/Login lokal (Soal SI-A)
  static const String _keyRegisteredUser = 'registered_username';
  static const String _keyRegisteredPass = 'registered_password';

  /// [SOAL SI-B / DEFAULT]: Menyimpan status session login aktif
  static Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyEmail, email);
  }

  /// Mengecek apakah user sedang dalam status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Mengambil email/username user yang sedang aktif
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  /// Alias getUsername() untuk kompatibilitas jika soal meminta 'username'
  static Future<String?> getUsername() async {
    return getEmail();
  }

  /// Menghapus session saat logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyEmail);
  }

  // ===========================================================================
  // [OPSI SOAL SI-A: REGISTER & VALIDASI LOGIN LOKAL]
  // ===========================================================================
  // Jika besok soal meminta validasi akun yang telah didaftarkan sebelumnya:
  
  /// Menyimpan kredensial baru saat Register
  static Future<void> registerAccount(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRegisteredUser, username);
    await prefs.setString(_keyRegisteredPass, password);
  }

  /// Memverifikasi kredensial login dengan akun yang terdaftar
  static Future<bool> verifyCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_keyRegisteredUser);
    final savedPass = prefs.getString(_keyRegisteredPass);

    // Jika belum pernah register, izinkan login jika tidak kosong (fallback)
    if (savedUser == null || savedPass == null) {
      return username.isNotEmpty && password.isNotEmpty;
    }

    return username == savedUser && password == savedPass;
  }
}
