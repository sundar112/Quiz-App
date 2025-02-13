// background_image.dart
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imagePath;
  final Widget child;

  const BackgroundImage({
    required this.imagePath,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath), // Use the provided image path
              //fit: BoxFit.cover, // Cover the entire screen
              opacity: 0.2,
            ),
          ),
        ),
        // Child Widget (Main Content)
        child,
      ],
    );
  }
}