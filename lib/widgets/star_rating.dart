import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double iconSize;
  final Function(double)? onRatingChanged; // 👈 Added this

  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.iconSize = 12,
    this.onRatingChanged, // 👈 Added this
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        IconData icon;
        if (index < rating.floor()) {
          icon = Icons.star;
        } else if (index < rating && rating - index >= 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(index + 1.0)
              : null,
          child: Icon(
            icon,
            color: Colors.amber,
            size: iconSize,
          ),
        );
      }),
    );
  }
}

