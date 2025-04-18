// lib/screens/puzzle_board_screen.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../widgets/masked_image.dart';

class PuzzleBoardScreen extends StatelessWidget {
  final ui.Image image;
  final Path maskPath;
  final Offset position;

  const PuzzleBoardScreen({
    super.key,
    required this.image,
    required this.maskPath,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: MaskedImage(image: image, maskPath: maskPath, position: position),
    );
  }
}
