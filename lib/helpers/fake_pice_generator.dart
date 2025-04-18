// import 'dart:ui' as ui;
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'image_cropper.dart';

// class FakePieceGenerator {
//   /// تولید ۵ قطعه‌ی اشتباهی
//   static Future<List<ui.Image>> generateFakePieces({
//     required ui.Image originalImage,
//     required ui.Image maskImage,
//     required Offset realOffset,
//     required int count,
//     double minDistance = 60,
//   }) async {
//     List<ui.Image> fakePieces = [];
//     Random random = Random();

//     double pieceWidth = maskImage.width.toDouble();
//     double pieceHeight = maskImage.height.toDouble();

//     while (fakePieces.length < count) {
//       double x = random.nextDouble() * (originalImage.width - pieceWidth);
//       double y = random.nextDouble() * (originalImage.height - pieceHeight);
//       Offset offset = Offset(x, y);

//       // چک کردن فاصله از قطعه واقعی
//       if ((offset - realOffset).distance >= minDistance) {
//         ui.Image fakePiece = await ImageCropper.cropWithMask(
//           originalImage: originalImage,
//           maskImage: maskImage,
//           position: offset,
//         );
//         fakePieces.add(fakePiece);
//       }
//     }

//     return fakePieces;
//   }
// }
