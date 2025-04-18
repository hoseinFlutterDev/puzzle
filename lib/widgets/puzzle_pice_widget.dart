// lib/widgets/puzzle_piece_widget.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PuzzlePieceWidget extends StatelessWidget {
  final ui.Image image;
  final Rect cropRect;
  final void Function()? onTap;
  final bool isCorrect;

  const PuzzlePieceWidget({
    super.key,
    required this.image,
    required this.cropRect,
    this.onTap,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        size: Size(cropRect.width, cropRect.height),
        painter: _PiecePainter(image, cropRect),
      ),
    );
  }
}

class _PiecePainter extends CustomPainter {
  final ui.Image image;
  final Rect cropRect;

  _PiecePainter(this.image, this.cropRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final src = cropRect;
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
