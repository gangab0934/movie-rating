import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          overflow: TextOverflow.ellipsis, // Handle long titles
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  movie.posterUrl,
                  height: isWideScreen ? 400 : 300, // Adjust height based on screen width
                  width: double.infinity,
                  fit: BoxFit.cover, // Ensures the image covers the entire box without distortion
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 300, // Fallback height
                    child: Center(
                      child: Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Movie Title
            Text(
              movie.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Rating with StarRating Widget
            Row(
              children: [
                const Text(
                  "Rating: ",
                  style: TextStyle(fontSize: 16),
                ),
                StarRating(rating: movie.rating, iconSize: 20),
              ],
            ),
            const SizedBox(height: 20),

            // Movie Overview Header
            Text(
              "Overview",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Movie Overview Text
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
