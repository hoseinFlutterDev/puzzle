import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MainImageWithHole extends StatelessWidget {
  final ui.Image image;
  final ui.Image mask;
  final Offset maskPosition;

  const MainImageWithHole({
    super.key,
    required this.image,
    required this.mask,
    required this.maskPosition,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      painter: _HolePainter(
        image: image,
        mask: mask,
        maskPosition: maskPosition,
      ),
    );
  }
}

class _HolePainter extends CustomPainter {
  final ui.Image image;
  final ui.Image mask;
  final Offset maskPosition;

  _HolePainter({
    required this.image,
    required this.mask,
    required this.maskPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);

    paint.blendMode = BlendMode.dstOut;

    canvas.drawImage(mask, maskPosition, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
