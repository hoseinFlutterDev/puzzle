// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';

// class PuzzleChoicesRow extends StatelessWidget {
//   final List<ui.Image> pieces;
//   final int correctIndex;
//   final void Function(bool isCorrect) onPieceSelected;

//   const PuzzleChoicesRow({
//     super.key,
//     required this.pieces,
//     required this.correctIndex,
//     required this.onPieceSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(pieces.length, (index) {
//         return GestureDetector(
//           onTap: () {
//             final isCorrect = index == correctIndex;
//             onPieceSelected(isCorrect);
//           },
//           child: RawImage(image: pieces[index], width: 60, height: 60),
//         );
//       }),
//     );
//   }
// }
