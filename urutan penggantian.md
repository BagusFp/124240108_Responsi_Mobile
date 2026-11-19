# 📋 PANDUAN URUTAN PENGGANTIAN FILE & CONTEKAN KODE RESPONSI

Dokumen ini adalah **panduan praktis langkah demi langkah** saat kamu menerima soal ujian/responsi.
Di setiap langkah, sudah dicantumkan **lokasi baris kode**, **status aktif saat ini**, dan **kode yang sedang dijadikan komentar** sehingga kamu tinggal buka/tutup komentar `/* ... */` tanpa perlu mengetik ulang dari nol!

---

## ⚡ RINGKASAN URUTAN EKSEKUSI:
```
[1. Buka Browser & Cek Struktur JSON Soal]
               │
               ▼
[2. lib/services/api_service.dart] ──> Pilih Versi 1 / 2 / 3 (Array vs Object results)
               │
               ▼
[3. lib/models/game_model.dart]   ──> Pilih factory fromJson Versi 1 / 2 / 3
               │
               ▼
[4. lib/widgets/game_card.dart]   ──> ListView Card vs GridView Card
               │
               ▼
[5. lib/pages/home_page.dart]     ──> Ganti Judul AppBar & Pilih ListView vs GridView
               │
               ▼
[6. lib/pages/detail_page.dart]   ──> Tampilkan data yang diminta soal
               │
               ▼
[7. lib/pages/login_page.dart]    ──> Pilih Skenario Login (Bebas / Hardcoded NIM / Register Hive)
               │
               ▼
[8. Test & Push ke GitHub]        ──> flutter run -d chrome -> git push
```

---

## 1. LANGKAH 1: ANALISIS SOAL & BENTUK JSON (2 Menit)
Buka endpoint API soal di browser Chrome. Perhatikan baris paling pertama dari JSON-nya:

| Bentuk JSON di Browser | Kategori / Contoh | Template yang Dipakai di Project |
| :--- | :--- | :--- |
| **Diawali Kurung Siku `[`**<br>`[ {"id": 1, ...}, {"id": 2, ...} ]` | **Array Langsung**<br>*(FreeToGame / TVMaze)* | Gunakan **VERSI 1** (FreeToGame) atau **VERSI 3** (TVMaze) |
| **Diawali Kurung Kurawal `{`**<br>`{ "count": 100, "results": [ ... ] }` | **Object Ber-Results**<br>*(SpaceNews / StarWars / Rick&Morty)* | Gunakan **VERSI 2** (SpaceNews) |

---

## 2. LANGKAH 2: GANTI KODE DI `lib/services/api_service.dart`
Buka file: [`lib/services/api_service.dart`](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/services/api_service.dart)

Di dalam file ini sudah tersedia **3 VERSI TEMPLATE LENGKAP**:

---

### 🟢 KONDISI A: Soal Game / Array Langsung `[...]` (SUDAH AKTIF)
> **Dipakai saat:** Soal bertema Game ("Hydra Games") atau API yang return-nya array `[...]`.
- **Status:** **AKTIF** di baris **21–53**.
- **Kodenya:**
```dart
static const String _baseUrl = 'https://www.freetogame.com/api';

static Future<List<Game>> getGames() async {
  final uri = Uri.parse('$_baseUrl/games');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // Array JSON langsung [...]
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Game.fromJson(item as Map<String, dynamic>)).toList();
  }
}
```

---

### 🟡 KONDISI B: Soal Berita / Object `{ "results": [...] }` (KOMENTAR DI BARIS 66–101)
> **Dipakai saat:** Soal meminta API yang dibungkus object, misal SpaceNews Explorer (`results`), Pokémon, atau Movie DB.
- **Cara Mengaktifkan:**
  1. Tutup Versi 1 di baris 21–53 dengan menambahkan `/*` di baris 21 dan `*/` di baris 53.
  2. Buka komentar pada baris 66–101 dengan **menghapus** tanda `/*` (baris 66) dan `*/` (baris 101).
- **Kodenya yang ada di komentar:**
```dart
static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

static Future<List<Game>> getGames() async {
  final uri = Uri.parse('$_baseUrl/articles');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // PENTING: Membongkar Object yang punya key 'results'
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> results = data['results'] as List<dynamic>? ?? [];
    return results.map((item) => Game.fromJson(item as Map<String, dynamic>)).toList();
  }
}

static Future<Game> getGameDetail(int id) async {
  // Path parameter: /$id
  final uri = Uri.parse('$_baseUrl/articles/$id');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return Game.fromJson(jsonDecode(response.body));
  }
}
```

---

### 🔵 KONDISI C: Soal TV Shows / Serial Film `[...]` (KOMENTAR DI BARIS 114–148)
> **Dipakai saat:** Soal bertema Film / TV Shows ("NontonSkuy!" TVMaze).
- **Cara Mengaktifkan:**
  1. Tutup Versi 1 di baris 21–53 dengan `/* ... */`.
  2. Buka komentar pada baris 114–148 dengan **menghapus** tanda `/*` (baris 114) dan `*/` (baris 148).
- **Kodenya yang ada di komentar:**
```dart
static const String _baseUrl = 'https://api.tvmaze.com';

static Future<List<Game>> getGames() async {
  final uri = Uri.parse('$_baseUrl/shows');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Game.fromJson(item as Map<String, dynamic>)).toList();
  }
}

static Future<Game> getGameDetail(int id) async {
  final uri = Uri.parse('$_baseUrl/shows/$id');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return Game.fromJson(jsonDecode(response.body));
  }
}
```

---

## 3. LANGKAH 3: GANTI MODEL DI `lib/models/game_model.dart`
Buka file: [`lib/models/game_model.dart`](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/models/game_model.dart)

Di file ini, parsing `fromJson` juga sudah disiapkan dalam 3 versi:

### 🟢 Versi 1 (AKTIF: Baris 57–121) - FreeToGame
* **Key API:** `id`, `title`, `thumbnail`, `genre`, `description`, `release_date`, `platform`.
* **Parsing List:** `genres: [json['genre']?.toString() ?? 'Game']`

### 🟡 Versi 2 (KOMENTAR: Baris 133–161) - SpaceNews
* **Key API:** `title`, `image_url`, `news_site`, `summary`, `published_at`, `url`, `authors`.
* **Cara Mengaktifkan:**
  1. Beri tanda `/*` di baris 57 dan `*/` di baris 121 (menutup Versi 1).
  2. Hapus `/*` di baris 133 dan `*/` di baris 161 (membuka Versi 2).
* **Kodenya:**
```dart
factory Game.fromJson(Map<String, dynamic> json) {
  return Game(
    id: json['id'] as int? ?? 0,
    title: json['title'] as String? ?? 'Tanpa Judul',
    thumbnail: json['image_url'] as String?,
    genres: json['news_site'] != null ? [json['news_site'].toString()] : ['News'],
    description: json['summary'] as String? ?? 'Tidak ada ringkasan berita.',
    platform: json['news_site'] as String? ?? 'SpaceNews',
    publisher: 'SpaceFlight',
    releaseDate: json['published_at'] as String? ?? '-',
    screenshots: [],
  );
}
```

### 🔵 Versi 3 (KOMENTAR: Baris 173–195) - TVMaze (Film)
* **Key API:** `name`, `image['medium']`, `genres`, `summary`, `rating['average']`, `premiered`.
* **Cara Mengaktifkan:**
  1. Beri tanda `/*` di baris 57 dan `*/` di baris 121 (menutup Versi 1).
  2. Hapus `/*` di baris 173 dan `*/` di baris 195 (membuka Versi 3).
* **Kodenya:**
```dart
factory Game.fromJson(Map<String, dynamic> json) {
  // Membersihkan tag HTML <p> dan <b> dari API TVMaze
  String cleanHtml(String? text) {
    if (text == null) return 'Tidak ada deskripsi.';
    return text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  return Game(
    id: json['id'] as int? ?? 0,
    title: json['name'] as String? ?? 'Tanpa Judul',
    thumbnail: json['image']?['medium'] as String?, // Nested JSON image.medium
    genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
    description: cleanHtml(json['summary'] as String?),
    platform: '⭐ Rating: ${json['rating']?['average'] ?? 'N/A'}',
    releaseDate: json['premiered'] as String? ?? '-',
    screenshots: [],
  );
}
```

---

## 4. LANGKAH 4: PILIH TAMPILAN DI `lib/pages/home_page.dart`
Buka file: [`lib/pages/home_page.dart`](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/pages/home_page.dart)

### A. Ganti Judul AppBar (Baris 132–139)
```dart
title: const Text('Browse Games'), // Ganti jadi 'SpaceNews' atau 'NontonSkuy!'
```

### B. Pilih Antara ListView (1 Kolom) vs GridView (Kotak 2 Kolom)
Cek baris **347–404** di `home_page.dart`:

* **PILIHAN 1: ListView Menurun (AKTIF - Baris 347–366)**
  ```dart
  return ListView.builder(
    itemCount: _filteredGames.length,
    itemBuilder: (context, index) {
      final game = _filteredGames[index];
      return GameCard(game: game, onTap: () => ...);
    },
  );
  ```

* **PILIHAN 2: GridView 2 Kolom (KOMENTAR - Baris 376–404)**
  *Jika di soal diminta tampilan grid kotak-kotak:*
  1. Pasang `/*` di baris 347 dan `*/` di baris 366.
  2. Hapus `/*` di baris 376 dan `*/` di baris 404.
  ```dart
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: _filteredGames.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 Kolom
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.72,
    ),
    itemBuilder: (context, index) {
      final game = _filteredGames[index];
      return GameGridCard(game: game, onTap: () => ...);
    },
  );
  ```

---

## 5. LANGKAH 5: PILIH SISTEM LOGIN DI `lib/pages/login_page.dart`
Buka file: [`lib/pages/login_page.dart`](file:///c:/Users/ADVAN/OneDrive/Documents/TUGAS%20KULIAH/prakmobile/latihan%20responsi/Wowok/lib/pages/login_page.dart)

Cek method `_handleLogin()` di baris **58–113**:

### 🟢 Skenario Default (AKTIF)
* Bebas login dengan username/email dan password apa pun asal tidak kosong.

### 🟡 Skenario Hardcoded NIM & Password (KOMENTAR: Baris 61–75)
*Jika dosen minta login harus pakai NIM kamu:*
* **Hapus komentar `/*` dan `*/` pada baris 61–75:**
```dart
const String correctNIM = '124240108'; // Sesuaikan NIM kamu
const String correctPassword = '123';  // Sesuaikan password soal
if (email != correctNIM || password != correctPassword) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Login Gagal! Username harus NIM & Password benar.')),
  );
  return;
}
```

### 🔵 Skenario Register Hive (KOMENTAR: Baris 99–112)
*Jika di soal SI-A harus register akun dulu:*
* **Hapus komentar `/*` dan `*/` pada baris 99–112:**
```dart
final bool isValid = await AuthStorage.verifyCredentials(email, password);
if (!isValid) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Login Gagal! Akun belum terdaftar di Register.')),
  );
  return;
}
```

---

## 6. LANGKAH 6: TESTING & PUSH KE GITHUB
Setelah mengubah pilihan di atas:

1. **Jalankan Analyzer** (Pastikan 0 error):
   ```bash
   flutter analyze
   ```
2. **Jalankan Aplikasi di Chrome**:
   ```bash
   flutter run -d chrome
   ```
3. **Push ke GitHub sesuai format Repo Ujian**:
   ```bash
   git init
   git add .
   git commit -m "feat: selesai responsi"
   git branch -M main
   git remote add origin https://github.com/USERNAME/NAMA_REPO_DARI_DOSEN.git
   git push -u origin main
   ```
