class Game {
  final int id;
  final String title;
  final String? thumbnail;
  final String? coverImage;
  final String ageRating;
  final int? episodeCount;
  final String averageRating;
  final List<String> genres;
  final String description;
  final String? shortDescription;
  final String? releaseDate;
  final String? platform;
  final String? publisher;
  final String? developer;
  final List<String> screenshots;
  Game({
    required this.id,
    required this.title,
    this.thumbnail,
    this.coverImage,
    this.ageRating = 'PG',
    this.episodeCount,
    this.averageRating = 'N/A',
    this.genres = const [],
    this.description = '',
    this.shortDescription,
    this.releaseDate,
    this.platform,
    this.publisher,
    this.developer,
    this.screenshots = const [],
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> item = json.containsKey('attributes')
        ? json
        : (json['data'] as Map<String, dynamic>?) ?? json;

    final Map<String, dynamic> attrs =
        (item['attributes'] as Map<String, dynamic>?) ?? {};

    final int parsedId = int.tryParse(item['id']?.toString() ?? '0') ?? 0;

    final titles = attrs['titles'] as Map<String, dynamic>?;
    final String parsedTitle = titles?['en_jp']?.toString() ?? 'Tanpa Judul';

    final posterMap = attrs['posterImage'] as Map<String, dynamic>?;
    final String? parsedPoster =
        posterMap?['small']?.toString() ??
        posterMap?['medium']?.toString() ??
        posterMap?['original']?.toString() ??
        posterMap?['tiny']?.toString();

    final coverMap = attrs['coverImage'] as Map<String, dynamic>?;
    final String? parsedCover =
        coverMap?['large']?.toString() ??
        coverMap?['small']?.toString() ??
        coverMap?['original']?.toString() ??
        coverMap?['tiny']?.toString() ??
        parsedPoster;

    final String parsedAgeRating = attrs['ageRating']?.toString() ?? 'PG';

    final int? parsedEpisodes = attrs['episodeCount'] as int?;

    final String parsedAverageRating =
        attrs['averageRating']?.toString() ?? 'N/A';

    final String parsedSynopsis =
        attrs['synopsis']?.toString() ?? 'Tidak ada sinopsis tersedia.';

    final String epString = parsedEpisodes != null
        ? '$parsedEpisodes Episodes'
        : 'N/A Episodes';
    final String parsedPlatform = '$parsedAgeRating • $epString';

    return Game(
      id: parsedId,
      title: parsedTitle,
      thumbnail: parsedPoster,
      coverImage: parsedCover,
      ageRating: parsedAgeRating,
      episodeCount: parsedEpisodes,
      averageRating: parsedAverageRating,
      description: parsedSynopsis,
      shortDescription: parsedSynopsis.length > 100
          ? '${parsedSynopsis.substring(0, 100)}...'
          : parsedSynopsis,
      releaseDate: attrs['startDate']?.toString(),
      platform: parsedPlatform,
      publisher: attrs['status']?.toString(),
      developer: attrs['subtype']?.toString(),
      genres: [parsedAgeRating],
      screenshots: parsedCover != null ? [parsedCover] : [],
    );
  }

  /// Konversi ke Map untuk disimpan di Hive (FavoriteStorage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'coverImage': coverImage,
      'ageRating': ageRating,
      'episodeCount': episodeCount,
      'averageRating': averageRating,
      'genres': genres,
      'description': description,
      'shortDescription': shortDescription,
      'releaseDate': releaseDate,
      'platform': platform,
      'publisher': publisher,
      'developer': developer,
      'screenshots': screenshots,
    };
  }

  /// Factory constructor dari Map di Hive
  factory Game.fromMap(Map<dynamic, dynamic> map) {
    return Game(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? 'Tanpa Judul',
      thumbnail: map['thumbnail'] as String?,
      coverImage: map['coverImage'] as String?,
      ageRating: map['ageRating'] as String? ?? 'PG',
      episodeCount: map['episodeCount'] as int?,
      averageRating: map['averageRating'] as String? ?? 'N/A',
      genres: (map['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description:
          map['description'] as String? ?? 'Tidak ada sinopsis tersedia.',
      shortDescription: map['shortDescription'] as String?,
      releaseDate: map['releaseDate'] as String?,
      platform: map['platform'] as String?,
      publisher: map['publisher'] as String?,
      developer: map['developer'] as String?,
      screenshots:
          (map['screenshots'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

typedef Anime = Game;
