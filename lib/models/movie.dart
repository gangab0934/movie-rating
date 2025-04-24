class Movie {
  final String title;
  final String overview;
  final String posterUrl;
  final double rating;
  bool isFavorite;

  Movie({
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    this.isFavorite = false,
  });
}
