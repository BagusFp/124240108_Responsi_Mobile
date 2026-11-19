import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../storage/favorite_storage.dart';
import '../utils/image_helper.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Game> _libraryGames = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  /// Memuat data dari Hive menggunakan getAt()
  void _loadFavorites() {
    setState(() {
      final box = FavoriteStorage.getBox();
      final List<Game> list = [];
      for (int i = 0; i < box.length; i++) {
        final data = box.getAt(i);
        if (data is Map) {
          list.add(Game.fromMap(data));
        }
      }
      _libraryGames = list;
    });
  }

  void _deleteFavorite(int index, Game game) async {
    await FavoriteStorage.deleteFavoriteAt(index);
    _loadFavorites();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${game.title} berhasil dihapus dari Favorite'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[850],
      ),
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
          'Favorite Anda',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _libraryGames.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_esports_outlined,
                    size: 72,
                    color: Colors.white.withAlpha(50),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada Favorite',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dapatkan Anime dari halaman Home untuk menyimpannya.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _libraryGames.length,
              itemBuilder: (context, index) {
                final game = _libraryGames[index];

                // Card Widget Item Library
                final itemCard = Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(gameId: game.id, initialGame: game),
                        ),
                      );
                      _loadFavorites();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          // 1. Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 80,
                              height: 55,
                              child: game.thumbnail != null
                                  ? Image.network(
                                      resolveImageUrl(game.thumbnail!),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: const Color(0xFF2C2C2C),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.white38,
                                                ),
                                              ),
                                    )
                                  : Container(
                                      color: const Color(0xFF2C2C2C),
                                      child: const Icon(
                                        Icons.sports_esports,
                                        color: Colors.white38,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (game.genres.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2C2C2C),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      game.genres.first,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 3),
                                if (game.platform != null &&
                                    game.platform!.isNotEmpty)
                                  Text(
                                    game.platform!,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // 3. Tombol Delete (Ikon Tong Sampah Merah Sesuai Mockup SI-B)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            tooltip: 'Hapus dari Favorite',
                            onPressed: () => _deleteFavorite(index, game),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                return itemCard;
              },
            ),
    );
  }
}
