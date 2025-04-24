import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;

  const StarRating({super.key, required this.rating, this.maxStars = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxStars, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
