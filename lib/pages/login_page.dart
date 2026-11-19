import 'package:flutter/material.dart';
import '../storage/auth_storage.dart';
import 'root_page.dart';
// [OPSI SOAL SI-A]: Uncomment import di bawah jika menggunakan Halaman Register
// ignore: unused_import
import 'register_page.dart';

/// ============================================================================
/// [HALAMAN LOGIN]
/// ============================================================================
/// - Soal SI-B (Default): Kredensial email & password bebas (validasi non-empty),
///   disimpan ke SharedPreferences via AuthStorage.saveSession(email).
/// - Soal SI-A (Opsi): Jika ada Halaman Register & validasi ketat, cukup
///   uncomment blok kode bertanda [OPSI SOAL SI-A] di bawah.
/// ============================================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 1. Validasi input tidak boleh kosong
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan Password tidak boleh kosong!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // =========================================================================
    // [OPSI SKENARIO 1: VALIDASI HARDCODED NIM & PASSWORD TERTENTU]
    // Uncomment blok di bawah jika soal meminta login wajib NIM + Password '123':

    const String correctNIM = '124240108'; // Sesuaikan NIM kamu
    const String correctPassword = '123'; // Sesuaikan password soal
    if (email != correctNIM || password != correctPassword) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login Gagal! Username harus NIM ($correctNIM) & Password ($correctPassword).',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // =========================================================================

    // =========================================================================
    // [OPSI SKENARIO 2: VALIDASI FORMAT EMAIL (HARUS MENGANDUNG '@')]
    // Uncomment blok di bawah jika email wajib ada '@':
    /*
    if (!email.contains('@')) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid! Harus mengandung tanda @.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    */
    // =========================================================================

    // =========================================================================
    // [OPSI SKENARIO 3 (SOAL SI-A): VALIDASI KREDENSIAL DENGAN HASIL REGISTER]
    // Uncomment blok di bawah jika akun harus terdaftar lewat RegisterPage:
    /*
    final bool isValid = await AuthStorage.verifyCredentials(email, password);
    if (!isValid) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Gagal! Akun belum terdaftar atau password salah.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    */
    // =========================================================================

    // 2. Simpan session login ke SharedPreferences
    await AuthStorage.saveSession(email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selamat datang, $email!'),
        backgroundColor: Colors.green,
      ),
    );

    // 3. Pindah ke RootPage (BottomNavigationBar)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Hydra Games (Sesuai Contoh Tampilan Soal SI-B)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 68, 0).withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.circle_outlined,
                    size: 64,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keripikroll',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 36),

                // Input Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white70,
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white60),
                    hintText: 'Masukkan email',
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2196F3)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Input Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white70,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white60,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white60),
                    hintText: 'Masukkan password',
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF2196F3)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Login (Warna Biru sesuai screenshot soal)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 33, 33),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // =============================================================
                // [OPSI SOAL SI-A: TOMBOL KE HALAMAN REGISTER]
                // Uncomment blok di bawah ini jika besok soal meminta ada Register:
                /*
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Belum punya akun? Register di sini',
                    style: TextStyle(color: Color(0xFF2196F3), fontSize: 13),
                  ),
                ),
                */
                // =============================================================
              ],
            ),
          ),
        ),
      ),
    );
  }
}
