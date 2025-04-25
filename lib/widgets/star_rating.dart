import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double iconSize;

  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxStars, (index) {
        IconData icon;
        if (index < rating.floor()) {
          icon = Icons.star;
        } else if (index < rating && rating - index >= 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(icon, color: Colors.amber, size: iconSize);
      }),
    );
  }
}
