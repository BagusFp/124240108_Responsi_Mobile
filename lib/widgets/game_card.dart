import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../utils/image_helper.dart';

/// ============================================================================
/// [WIDGET 1: KARTU LISTVIEW HORIZONTAL (1 KOLOM MENURUN)]
/// ============================================================================
/// Digunakan pada tampilan ListView.builder (Default Soal SI-B)
/// ============================================================================

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0xFF1E1E1E),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Gambar Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 95,
                  height: 60,
                  child: game.thumbnail != null
                      ? Image.network(
                          resolveImageUrl(game.thumbnail!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF2C2C2C),
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.white38, size: 24),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF2C2C2C),
                              child: const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF2C2C2C),
                          child: const Center(
                            child: Icon(Icons.sports_esports, color: Colors.white38, size: 24),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // 2. Info: Nama, Genre, Platform
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Game
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Genre Chip (Sesuai mockup SI-B)
                    if (game.genres.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          game.genres.first,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),

                    // Platform Game (PC Windows / Web Browser)
                    if (game.platform != null && game.platform!.isNotEmpty)
                      Text(
                        game.platform!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Indikator Chevron '>' Sesuai Screenshot
              const Icon(
                Icons.chevron_right,
                color: Colors.white38,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [WIDGET 2: KARTU GRIDVIEW KOTAK (2 KOLOM MENYAMPING)]
/// ============================================================================
/// Digunakan jika soal responsi meminta tampilan Grid (GridView.builder).
/// Menampilkan poster di bagian atas dan judul + metadata di bagian bawah.
/// ============================================================================

class GameGridCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameGridCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFF1E1E1E),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Poster / Thumbnail di atas
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: game.thumbnail != null
                    ? Image.network(
                        resolveImageUrl(game.thumbnail!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF2C2C2C),
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.white38),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF2C2C2C),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFF2C2C2C),
                        child: const Center(
                          child: Icon(Icons.sports_esports, color: Colors.white38),
                        ),
                      ),
              ),
            ),

            // Teks Info di bawah
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (game.genres.isNotEmpty)
                        Flexible(
                          child: Text(
                            game.genres.first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (game.platform != null && game.platform!.isNotEmpty)
                        Flexible(
                          child: Text(
                            game.platform!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alias typedef agar jika ada file lama mengimpor ShowCard tidak crash
typedef ShowCard = GameCard;
