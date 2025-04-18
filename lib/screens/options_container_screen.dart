// lib/screens/options_container_screen.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:puzzle_test/widgets/puzzle_pice_widget.dart';

class OptionsContainerScreen extends StatelessWidget {
  final ui.Image image;
  final List<Rect> pieceRects;
  final int correctIndex;
  final void Function(int index) onSelected;

  const OptionsContainerScreen({
    super.key,
    required this.image,
    required this.pieceRects,
    required this.correctIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pieceRects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PuzzlePieceWidget(
              image: image,
              cropRect: pieceRects[index],
              onTap: () => onSelected(index),
              isCorrect: index == correctIndex,
            ),
          );
        },
      ),
    );
  }
}
