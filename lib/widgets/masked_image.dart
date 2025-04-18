// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

// class MaskedImage extends StatelessWidget {
//   final String imagePath;  // مسیر تصویر
//   final String maskPath;   // مسیر فایل SVG ماسک
//   final Offset position;   // موقعیت قرارگیری تصویر

//   MaskedImage({
//     required this.imagePath,
//     required this.maskPath,
//     required this.position,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(300, 300),  // اندازه تصویر
//       painter: MaskedImagePainter(imagePath: imagePath, maskPath: maskPath, position: position),
//     );
//   }
// }

// class MaskedImagePainter extends CustomPainter {
//   final String imagePath;
//   final String maskPath;
//   final Offset position;

//   MaskedImagePainter({
//     required this.imagePath,
//     required this.maskPath,
//     required this.position,
//   });

//   @override
//   void paint(Canvas canvas, Size size) async {
//     final paint = Paint();

//     // بارگذاری تصویر اصلی
//     final image = await _loadImage(imagePath);
//     canvas.drawImage(image, position, paint);

//     // بارگذاری SVG و رسم آن روی Canvas
//     await _drawSVGMask(canvas, size);
//   }

//   Future<Image> _loadImage(String imagePath) async {
//     final data = await rootBundle.load(imagePath);  // بارگذاری تصویر
//     final bytes = data.buffer.asUint8List();
//     final image = await decodeImageFromList(bytes);
//     return image;
//   }

//   // بارگذاری SVG و رسم آن روی Canvas
//   Future<void> _drawSVGMask(Canvas canvas, Size size) async {
//     final svgString = await rootBundle.loadString(maskPath);  // بارگذاری SVG از مسیر
//     final DrawableRoot svgRoot = await svg.fromSvgString(svgString, maskPath);  // تبدیل به ریشه SVG

//     // رسم SVG روی Canvas
//     svgRoot.paint(canvas, size);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
