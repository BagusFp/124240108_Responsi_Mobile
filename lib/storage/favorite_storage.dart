import 'package:hive/hive.dart';
import '../models/game_model.dart';

class FavoriteStorage {
  static const String boxName = 'favoritesBox';

  /// Mendapatkan box Hive yang sudah terbuka
  static Box getBox() {
    return Hive.box(boxName);
  }

  /// Menambahkan game ke Hive menggunakan method .add()
  static Future<void> addFavorite(Game game) async {
    final box = getBox();
    // Cek agar tidak duplikat
    if (!isFavorite(game.id)) {
      await box.add(game.toMap());
    }
  }

  /// Mengambil game berdasarkan index menggunakan method .getAt()
  static Game getFavoriteAt(int index) {
    final box = getBox();
    final data = box.getAt(index);
    return Game.fromMap(data as Map);
  }

  /// Menghapus game berdasarkan index menggunakan method .deleteAt()
  static Future<void> deleteFavoriteAt(int index) async {
    final box = getBox();
    await box.deleteAt(index);
  }

  /// Mengecek apakah sebuah game dengan ID tertentu sudah ada di favorit / library
  static bool isFavorite(int gameId) {
    final box = getBox();
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item is Map && item['id'] == gameId) {
        return true;
      }
    }
    return false;
  }

  /// Menghapus game berdasarkan ID (mencari index lalu memanggil .deleteAt)
  static Future<void> removeFavoriteById(int gameId) async {
    final box = getBox();
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item is Map && item['id'] == gameId) {
        await box.deleteAt(i);
        break;
      }
    }
  }

  /// Mengambil semua daftar game yang ada di library / favorit
  static List<Game> getAllFavorites() {
    final box = getBox();
    final List<Game> list = [];
    for (int i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data is Map) {
        list.add(Game.fromMap(data));
      }
    }
    return list;
  }
}
