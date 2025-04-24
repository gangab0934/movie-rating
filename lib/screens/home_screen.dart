import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = dummyMovies;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];

    setState(() {
      for (var movie in movies) {
        movie.isFavorite = saved.contains(movie.title);
      }
    });
  }

  void toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];

    setState(() {
      movie.isFavorite = !movie.isFavorite;
    });

    if (movie.isFavorite) {
      saved.add(movie.title);
    } else {
      saved.remove(movie.title);
    }

    await prefs.setStringList('favorites', saved.toSet().toList());
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = movies
        .where((m) =>
        m.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredMovies.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(movie: movie),
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            movie.posterUrl,
                            height:180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                            const SizedBox(
                              height:180,
                              child: Center(
                                child: Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("⭐️ ${movie.rating}"),
                              IconButton(
                                icon: Icon(
                                  movie.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: movie.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () => toggleFavorite(movie),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
