import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class ApiService {
  static const String _baseUrl = 'https://kitsu.io/api/edge';

  /// Mengambil daftar semua anime (20 anime pertama)
  static Future<List<Game>> getGames() async {
    final uri = Uri.parse('$_baseUrl/anime/?page[limit]=20&page[offset]=0');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil daftar anime (Status: ${response.statusCode})',
      );
    }
  }

  static Future<Game> getGameDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/anime/$id');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> item =
          json['data'] as Map<String, dynamic>? ?? json;
      return Game.fromJson(item);
    } else {
      throw Exception('Gagal mengambil $id (Status: ${response.statusCode})');
    }
  }
}
