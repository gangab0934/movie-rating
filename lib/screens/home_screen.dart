import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import '../widgets/star_rating.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter movies based on search query
    final filteredMovies = movies
        .where((m) => m.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[200],
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          // GridView for displaying movies
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMovies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2, // Adjust grid columns based on screen width
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.6,
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie poster
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            movie.posterUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                          ),
                        ),
                        // Movie title
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Movie rating and favorite button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StarRating(rating: movie.rating, iconSize: 20),
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
