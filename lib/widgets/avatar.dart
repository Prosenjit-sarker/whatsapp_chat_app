import 'package:flutter/material.dart';
import '../theme.dart';

class ChatAvatar extends StatelessWidget {
  final String seed;
  final bool isGroup;
  final double radius;

  const ChatAvatar({
    super.key,
    required this.seed,
    this.isGroup = false,
    this.radius = 26,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorFor(seed);
    final initials = seed.length >= 2 ? seed.substring(0, 2) : seed;

    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: isGroup
          ? Icon(Icons.groups_rounded, color: Colors.white, size: radius)
          : Text(
        initials.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}
