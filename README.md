# MASTER CHEATSHEET & PANDUAN LENGKAP RESPONSI PEMROGRAMAN MOBILE

> **Buku Saku & Panduan Ujian Responsi Praktikum Pemrograman Mobile**  
> Dokumen ini dirancang sebagai referensi super lengkap menghadapi berbagai variasi soal responsi (Plug SI-A, SI-B, maupun SI-F). Seluruh fitur, service, model, dan trik pengerjaan kilat telah diuji dan siap digunakan.

---

## 1. Tabel Perbandingan 3 Soal Responsi

Berikut perbandingan fitur dan API dari 3 kelas sebelumnya:

| Aspek / Fitur          | Soal Plug SI-A (SpaceNews)                                    | Soal Plug SI-B (Hydra Games)                       | Soal Plug SI-F (TVMaze Shows)                    |
| ---------------------- | ------------------------------------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| **Tema Aplikasi**      | Berita Luar Angkasa                                           | Katalog & Library Game                             | Streaming Series / TV Shows                      |
| **Base URL**           | `https://api.spaceflightnewsapi.net/v4`                       | `https://www.freetogame.com/api`                   | `https://api.tvmaze.com`                         |
| **Endpoint List**      | `/articles`                                                   | `/games`                                           | `/shows`                                         |
| **Bentuk Respon List** | **Object `{results: [...]}`** (harus ambil `data['results']`) | **Array Langsung `[...]`** (langsung `data.map`)   | **Array Langsung `[...]`** (langsung `data.map`) |
| **Endpoint Detail**    | Path Param: `/articles/{id}` (`/$id`)                         | Query Param: `/game?id={id}` (`?id=$id`)           | Path Param: `/shows/{id}` (`/$id`)               |
| **Autentikasi**        | Register & Login (Database Lokal)                             | Login Email & Password bebas                       | Login Username NIM & Password `123`              |
| **Navigasi Utama**     | Tombol Bookmark di AppBar kanan                               | BottomNavigationBar (Beranda, Library, Profil)     | BottomNavigationBar (Home, Favorit, Profil)      |
| **Tampilan Utama**     | Minimal 10 item (Gambar, Judul, News Site, Tanggal)           | ListView (Thumbnail, Nama, Genre, Platform)        | Grid/List (Gambar, Judul, Rating)                |
| **Detail Action**      | Tombol Read Full Article (`url_launcher`) & Bookmark          | Tombol `+ Get` (aktif) / `✓ In Library` (nonaktif) | Tombol Tambah/Hapus Favorit                      |
| **Hapus Favorit**      | **Swipe to Delete (Dismissible)**                             | Tombol Tempat Sampah Merah                         | Tombol Hapus                                     |
| **Local Storage**      | Local Database (Hive / SharedPref)                            | Hive (`favoritesBox`) & SharedPref (Session)       | Hive (`favoritesBox`) & SharedPref (Session)     |

---

## 2. Struktur File Project & Perannya

```text
lib/
├── main.dart                      # Inisialisasi Hive, SharedPreferences, & Thema Aplikasi
├── models/
│   ├── game_model.dart            # Model serbaguna (memuat 3 versi fromJson: FreeToGame, SpaceNews, TVMaze)
│   └── article_model.dart         # Model alternatif jika menggunakan tema SpaceNews
├── services/
│   ├── api_service.dart           # Service API (memuat 3 versi endpoint: FreeToGame, SpaceNews, TVMaze)
│   ├── spacenews_service.dart     # Service alternatif SpaceNews
│   ├── notification_service.dart  # [BONUS] Local Notification langsung (Immediate)
│   └── location_service.dart      # [BONUS] Location-Based Services (Geolocator)
├── storage/
│   ├── auth_storage.dart          # Session login & penyimpanan akun register
│   └── favorite_storage.dart      # Operasi CRUD Hive Box (add, getAt, deleteAt, isFavorite)
├── utils/
│   └── image_helper.dart          # Solusi penanganan CORS gambar di browser Chrome
├── widgets/
│   ├── game_card.dart             # Menyediakan GameCard (ListView) & GameGridCard (GridView 2 kolom)
│   └── show_card.dart             # Re-export compatibility wrapper
└── pages/
    ├── root_page.dart             # BottomNavigationBar (Beranda, Library, Profil)
    ├── login_page.dart            # Form login dengan opsi Bebas, NIM/Password, atau Register
    ├── register_page.dart         # [SIAP PAKAI] Halaman pendaftaran akun baru
    ├── home_page.dart             # Halaman utama (ListView / GridView, Search bar, Category Filter)
    ├── detail_page.dart           # Halaman detail (Hero image, info kolom, action button, overview)
    ├── favorite_page.dart         # Halaman koleksi (tombol hapus merah & opsi Dismissible swipe)
    ├── profile_page.dart          # Tampilan akun, counter koleksi, tombol logout, shortcut LBS
    └── notification_lbs_page.dart # Halaman demo fitur bonus praktikum
```

---

## 3. Trik Emas Pemodelan Data (`String` vs `List<String>`)

Bagian ini sering membingungkan saat membuat `game_model.dart`:

### A. Kapan Menggunakan `final String`?

Gunakan `String` ketika nilai pada JSON adalah **teks tunggal** yang diapit tanda petik `"..."`.

```dart
// Deklarasi di Model:
final String title;
final String? releaseDate; // Tanda ? artinya boleh bernilai null

// Cara Parse di fromJson:
title: json['title'] as String? ?? 'Tanpa Judul',
releaseDate: json['release_date'] as String? ?? '-',
```

### B. Kapan Menggunakan `final List<String>`?

Gunakan `List<String>` ketika nilai pada JSON diawali **kurung siku `[...]`** (berisi banyak data sekaligus).

```dart
// Deklarasi di Model:
final List<String> genres;

// Cara Parse di fromJson (Wajib gunakan .map dan .toList):
genres: (json['genres'] as List?)
    ?.map((e) => e.toString())
    .toList() ?? [],
```

### C. Trik Bungkus String Tunggal Menjadi List

Jika di JSON berupa string tunggal (misal FreeToGame: `"genre": "Shooter"`), tapi UI kita memanggil `.join(', ')` atau `.first`:

```dart
// Bungkus string tunggal dengan kurung siku [ ... ]:
genres: json['genre'] != null ? [json['genre'].toString()] : [],
```

---

## 4. Cara Menukar 3 Versi API (FreeToGame vs SpaceNews vs TVMaze)

Di dalam [lib/services/api_service.dart](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/services/api_service.dart) dan [lib/models/game_model.dart](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/models/game_model.dart) sudah disiapkan 3 template lengkap:

### Cara Mengetahui Endpoint dari Lembar Soal:

1. Cari teks **"Link API"** atau **"Endpoint"** di soal.
2. Bagian domain adalah `_baseUrl` (misal `https://api.tvmaze.com`).
3. Kata setelah garis miring adalah endpoint list (misal `/shows`, `/games`, atau `/articles`).
4. Jika ada `{id}`, berarti endpoint detail. Perhatikan apakah pakai garis miring `/$id` atau tanda tanya `?id=$id`.

### Panduan Ganti Versi:

- **Jika Soal Game (FreeToGame - SI-B)**:
  - Tidak perlu ubah apa-apa, **VERSI 1** sudah aktif secara default.
- **Jika Soal Berita (SpaceNews - SI-A)**:
  1. Di `api_service.dart` & `game_model.dart`, kunci **VERSI 1** dengan `/* ... */`.
  2. Buka kunci **VERSI 2** dengan menghapus `/*` dan `*/`.
- **Jika Soal Serial Film (TVMaze - SI-F)**:
  1. Di `api_service.dart` & `game_model.dart`, kunci **VERSI 1** dengan `/* ... */`.
  2. Buka kunci **VERSI 3** dengan menghapus `/*` dan `*/`.

---

## 5. Cara Mengganti Tampilan (ListView vs GridView 2 Kolom)

Buka [lib/pages/home_page.dart](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/pages/home_page.dart#L320-L388) pada method `_buildContent()`:

### Dari ListView Menurun ke GridView 2 Kotak Menyamping:

1. Kunci blok `return ListView.builder(...);` dengan tanda `/*` di atas dan `*/` di bawah.
2. Hapus tanda `/*` dan `*/` pada blok `return GridView.builder(...)` tepat di bawahnya.
3. Simpan (`Ctrl + S`), tampilan otomatis berubah menjadi kotak-kotak 2 kolom menggunakan `GameGridCard`.

---

## 6. Opsi Validasi Login di `login_page.dart`

Buka [lib/pages/login_page.dart](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/pages/login_page.dart#L56-L95):

1. **Default Aktif (Soal SI-B)**: Email & password bebas asal tidak kosong.
2. **Skenario 1 (NIM & Password '123')**: Uncomment blok `SKENARIO 1` jika pengawas meminta login hardcoded NIM mahasiswa.
3. **Skenario 2 (Format Email '@')**: Uncomment blok `SKENARIO 2` jika email wajib ada `@`.
4. **Skenario 3 (Validasi Hasil Register - Soal SI-A)**: Uncomment blok `SKENARIO 3` dan uncomment tombol register di bagian bawah.

---

## 7. Troubleshooting Masalah Nyata & Solusinya

Berikut rangkuman solusi dari masalah yang sering terjadi saat latihan:

### A. Gambar Game Tidak Muncul Saat di-Run di Chrome (CORS Issue)

- **Penyebab**: Server CDN (FreeToGame) tidak menyertakan header `Access-Control-Allow-Origin: *`. Browser Chrome memblokir CanvasKit saat memuat byte gambar.
- **Di Android & Windows**: Masalah ini **sama sekali tidak ada** (karena aplikasi native tidak dibatasi browser CORS).
- **Solusi Otomatis**: Gunakan fungsi `resolveImageUrl(url)` dari [lib/utils/image_helper.dart](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/utils/image_helper.dart). Fungsi ini otomatis mendeteksi platform Web (`kIsWeb`) dan mengalirkannya via proxy `images.weserv.nl`.

### B. Error Kompilasi Android SDK 37 & AGP 9.1.0 (`flutter_local_notifications`)

- **Penyebab**: Plugin `flutter_local_notifications` versi 23 ke atas mewajibkan Android SDK 37 dan AGP 9.1.0+.
- **Solusi**: Gunakan versi stabil `22.3.2` di `pubspec.yaml` dan aktifkan desugaring di `android/app/build.gradle.kts`:
  ```kotlin
  compileOptions {
      isCoreLibraryDesugaringEnabled = true
  }
  dependencies {
      coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  }
  ```

### C. Fitur Notifikasi Jadwal 5 Detik Gagal / Crash

- **Penyebab**: Android 12+ (API 31+) melarang penjadwalan alarm presisi (`zonedSchedule`) tanpa izin khusus `SCHEDULE_EXACT_ALARM`.
- **Solusi**: Gunakan **Immediate Local Notification** (`showImmediateNotification`) yang langsung muncul di tray status bar tanpa batasan izin alarm.

---

## 8. Panduan Lengkap Push ke GitHub & Pengumpulan SPADA

Karena folder latihan ini sebelumnya sudah diputuskan dari Git, ikuti tutorial langkah demi langkah di bawah ini saat ujian responsi selesai:

---

### LANGKAH 1: Buat Repositori Baru di GitHub

1. Buka browser dan login ke akun [github.com](https://github.com).
2. Klik tombol **New** (atau ikon **+** di pojok kanan atas -> **New repository**).
3. **Repository Name**: Masukkan nama sesuai format yang tertulis di lembar soal responsi:
   - **Format Tipe 1 (Soal SI-A / SI-B)**: `[NIM]_Responsi_Mobile`  
     _(Contoh: `124240108_Responsi_Mobile`)_
   - **Format Tipe 2 (Soal SI-F)**: `Latres_Mobile_[NIM]`  
     _(Contoh: `Latres_Mobile_124240108`)_
4. **Visibility**: Pilih **PUBLIC** _(PENTING: Jangan pilih Private agar asisten praktikum bisa membuka dan menilai kode kamu!)_.
5. **PENTING**: Biarkan bagian _"Add a README file"_, _"Add .gitignore"_, dan _"Choose a license"_ **KOSONG / JANGAN DICENTANG** (karena project di laptopmu sudah memiliki berkas tersebut).
6. Klik tombol hijau **Create repository**.

---

### LANGKAH 2: Jalankan Perintah Git di Terminal VS Code

Buka Terminal di VS Code (`Ctrl + ~`), pastikan berada di folder project, lalu jalankan perintah berikut secara berurutan:

```bash
# 1. Inisialisasi Git baru di folder project
git init

# 2. Tambahkan seluruh berkas project ke staging area
git add .

# 3. Buat commit pertama
git commit -m "feat: complete responsi mobile"

# 4. Pastikan branch utama bernama main
git branch -M main

# 5. Hubungkan ke repositori GitHub yang baru kamu buat
# (GANTI [USERNAME] dan [NAMA_REPO] dengan milikmu sendiri!)
git remote add origin https://github.com/BagusFp/124240108_Responsi_Mobile.git

# Contoh jika akunmu "BagusFp" dan nama repo "124240108_Responsi_Mobile":
# git remote add origin https://github.com/BagusFp/124240108_Responsi_Mobile.git

# 6. Upload (push) kode ke GitHub
git push -u origin main
```

---

### LANGKAH 3: Troubleshooting Error Git yang Sering Terjadi

1. **Error: `remote origin already exists`**:
   - Solusi: Hapus remote lama lalu tambahkan yang baru:
     ```bash
     git remote remove origin
     git remote add origin https://github.com/BagusFp/124240108_Responsi_Mobile.git
     git push -u origin main
     ```
2. **Muncul Jendela Login GitHub**:
   - Pilih opsi **Sign in with your browser**, klik **Authorize GitCredentialManager**, dan proses push akan langsung berlanjut otomatis.
3. **Error: `Updates were rejected because the remote contains work...`**:
   - Penyebab: Kamu mencentang _Add README_ saat membuat repo di web GitHub.
   - Solusi: Paksa push kode laptopmu menimpa repo kosong tersebut:
     ```bash
     git push -u origin main --force
     ```

---

### LANGKAH 4: Pengumpulan di SPADA

1. Buka kembali halaman repositorimu di GitHub pada browser.
2. Salin URL di address bar (misal: `https://github.com/BagusFp/124240108_Responsi_Mobile`).
3. Buka platform **SPADA**, masuk ke tugas Responsi Pemrograman Mobile, dan tempelkan (_paste_) link GitHub tersebut sebelum batas waktu 120 menit berakhir!
