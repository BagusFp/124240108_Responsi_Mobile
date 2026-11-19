import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';
import '../storage/auth_storage.dart';
import '../widgets/game_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Game> _allGames = [];
  List<Game> _filteredGames = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  // Username login untuk opsi Soal SI-A
  // ignore: unused_field
  String _currentUsername = 'User';

  // Kategori terpilih untuk fitur Filter (Soal SI-A: Filter Berita / Genre)
  String _selectedGenre = 'Semua';
  List<String> _availableGenres = ['Semua'];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchGames();
    _searchController.addListener(_applyFilterAndSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUser() async {
    final name = await AuthStorage.getUsername();
    if (mounted && name != null) {
      setState(() => _currentUsername = name);
    }
  }

  Future<void> _fetchGames() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final games = await ApiService.getGames();
      if (mounted) {
        final Set<String> genresSet = {'Semua'};
        for (final g in games) {
          if (g.genres.isNotEmpty) genresSet.add(g.genres.first);
        }

        setState(() {
          _allGames = games;
          _filteredGames = games;
          _availableGenres = genresSet.take(8).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _applyFilterAndSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredGames = _allGames.where((game) {
        // Filter Pencarian Teks
        final matchSearch =
            query.isEmpty ||
            game.title.toLowerCase().contains(query) ||
            game.genres.any((g) => g.toLowerCase().contains(query)) ||
            (game.platform != null &&
                game.platform!.toLowerCase().contains(query));
        final matchGenre =
            _selectedGenre == 'Semua' || game.genres.contains(_selectedGenre);

        return matchSearch && matchGenre;
      }).toList();
    });
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
          'Keripikroll',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _fetchGames,
        color: const Color.fromARGB(255, 255, 1, 1),
        backgroundColor: const Color(0xFF1E1E1E),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari judul game, genre, platform...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white60),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white60),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (_availableGenres.length > 1)
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _availableGenres.length,
                  itemBuilder: (context, index) {
                    final genre = _availableGenres[index];
                    final isSelected = genre == _selectedGenre;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(genre),
                        selected: isSelected,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        selectedColor: const Color(0xFF2196F3),
                        backgroundColor: const Color(0xFF1E1E1E),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF333333),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGenre = genre;
                          });
                          _applyFilterAndSearch();
                        },
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 6),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2196F3)),
            SizedBox(height: 16),
            Text(
              'Memuat data game...',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Mengambil Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchGames,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_filteredGames.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, color: Colors.white38, size: 54),
            SizedBox(height: 12),
            Text(
              'Tidak ada game yang cocok.',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredGames.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return GameGridCard(
          game: game,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailPage(gameId: game.id, initialGame: game),
              ),
            );
          },
        );
      },
    );
  }
}
