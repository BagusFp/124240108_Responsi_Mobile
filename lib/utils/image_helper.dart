import 'package:flutter/foundation.dart';

/// ============================================================================
/// [HELPER GAMBAR: SOLUSI CORS FLUTTER WEB (CHROME)]
/// ============================================================================
/// Mengapa gambar FreeToGame tidak muncul saat di-run di Chrome?
/// 
/// 1. PENYEBAB:
///    Server CDN FreeToGame (Cloudflare) tidak mengirim header:
///    `Access-Control-Allow-Origin: *`.
///    Browser Chrome memiliki aturan keamanan CORS (Cross-Origin Resource Sharing).
///    Ketika Flutter Web (CanvasKit) mencoba mem-fetch byte gambar untuk digambar
///    di HTML5 Canvas, Chrome memblokirnya karena dianggap cross-origin tanpa izin.
/// 
/// 2. PADA RESPONSI ASLI (ANDROID / WINDOWS):
///    Masalah ini HANYA terjadi di browser Web (Chrome).
///    Pada perangkat Android (Emulator / HP) atau Windows Desktop, CORS TIDAK BERLAKU
///    karena aplikasi native menggunakan HTTP socket langsung tanpa sandbox browser.
/// 
/// 3. SOLUSI:
///    Fungsi ini mengecek `kIsWeb`. Jika dijalankan di Web (Chrome), URL diarahkan
///    melalui reverse-proxy CORS resmi `images.weserv.nl` agar gambar bisa tampil.
///    Jika dijalankan di Android / Windows (`kIsWeb == false`), URL asli digunakan langsung.
/// ============================================================================

String resolveImageUrl(String? url) {
  if (url == null || url.trim().isEmpty) return '';
  final cleanUrl = url.trim();

  // Khusus Web / Chrome: gunakan proxy CORS
  if (kIsWeb) {
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(cleanUrl)}';
  }

  // Android & Windows Desktop: gunakan URL asli langsung
  return cleanUrl;
}

