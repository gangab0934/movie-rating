class Movie {
  final String title;
  final String overview;
  final String posterUrl;
  double rating;  // <-- remove "final"
  bool isFavorite;

  Movie({
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    this.isFavorite = false,
  });
}

