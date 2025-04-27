import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.movie.rating;
  }

  String getRatingPercentage(double rating) {
    double percentage = (rating / 5) * 100;
    return "${percentage.toStringAsFixed(0)}%"; // Rounded to 0 decimal
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          overflow: TextOverflow.ellipsis,
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
                  widget.movie.posterUrl,
                  height: isWideScreen ? 400 : 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 300,
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
              widget.movie.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Interactive Rating and Rating Percentage
            Row(
              children: [
                const Text(
                  "Rating: ",
                  style: TextStyle(fontSize: 16),
                ),
                StarRating(
                  rating: _currentRating,
                  iconSize: 24,
                  onRatingChanged: (newRating) {
                    setState(() {
                      _currentRating = newRating;
                      widget.movie.rating = newRating;
                    });
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  "${_currentRating.toStringAsFixed(1)} / 5", // show stars like 4.5/5
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  getRatingPercentage(_currentRating), // Show 90% etc.
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Overview Header
            Text(
              "Overview",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Movie Overview Text
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
