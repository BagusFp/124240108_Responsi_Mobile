import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/game_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

void main() {
  group('Game Model Tests', () {
    test('Game.fromJson parses valid JSON properly', () {
      final json = {
        'id': 452,
        'title': 'Call of Duty: Warzone',
        'thumbnail': 'https://www.freetogame.com/g/452/thumbnail.jpg',
        'short_description': 'A standalone free-to-play battle royale.',
        'description': 'A standalone free-to-play battle royale and modes accessible via Call of Duty: Modern Warfare.',
        'genre': 'Shooter',
        'platform': 'Windows',
        'publisher': 'Activision',
        'developer': 'Infinity Ward',
        'release_date': '2020-03-10',
        'screenshots': [
          {'id': 1124, 'image': 'https://www.freetogame.com/g/452/Call-of-Duty-Warzone-1.jpg'}
        ],
      };

      final game = Game.fromJson(json);
      expect(game.id, 452);
      expect(game.title, 'Call of Duty: Warzone');
      expect(game.thumbnail, 'https://www.freetogame.com/g/452/thumbnail.jpg');
      expect(game.genres, ['Shooter']);
      expect(game.description, 'A standalone free-to-play battle royale and modes accessible via Call of Duty: Modern Warfare.');
      expect(game.platform, 'Windows');
      expect(game.publisher, 'Activision');
      expect(game.developer, 'Infinity Ward');
      expect(game.releaseDate, '2020-03-10');
      expect(game.screenshots.length, 1);
    });

    test('Game toMap and fromMap works seamlessly for Hive', () {
      final gameOriginal = Game(
        id: 452,
        title: 'Call of Duty: Warzone',
        thumbnail: 'https://www.freetogame.com/g/452/thumbnail.jpg',
        genres: ['Shooter'],
        description: 'Battle royale game.',
        shortDescription: 'Battle royale.',
        releaseDate: '2020-03-10',
        platform: 'Windows',
        publisher: 'Activision',
        developer: 'Infinity Ward',
        screenshots: ['https://example.com/shot1.jpg'],
      );

      final map = gameOriginal.toMap();
      final fromHive = Game.fromMap(map);

      expect(fromHive.id, 452);
      expect(fromHive.title, 'Call of Duty: Warzone');
      expect(fromHive.thumbnail, 'https://www.freetogame.com/g/452/thumbnail.jpg');
      expect(fromHive.genres, ['Shooter']);
      expect(fromHive.description, 'Battle royale game.');
      expect(fromHive.platform, 'Windows');
      expect(fromHive.publisher, 'Activision');
      expect(fromHive.developer, 'Infinity Ward');
      expect(fromHive.releaseDate, '2020-03-10');
      expect(fromHive.screenshots, ['https://example.com/shot1.jpg']);
    });
  });

  group('FreeToGame API Live Tests', () {
    test('getGames fetches list of games successfully', () async {
      final games = await ApiService.getGames();
      expect(games.isNotEmpty, true);
      expect(games.first.id, greaterThan(0));
      expect(games.first.title.isNotEmpty, true);
    });

    test('getGameDetail fetches single game details', () async {
      final game = await ApiService.getGameDetail(452);
      expect(game.id, 452);
      expect(game.title, 'Call of Duty: Warzone');
    });
  });
}
