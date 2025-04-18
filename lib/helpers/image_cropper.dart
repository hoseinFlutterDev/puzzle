// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/widgets.dart';

// class ImageCropper {
//   // این تابع مسئول بریدن تصویر با استفاده از مسیر SVG است
//   static Image cropImageWithSVG(
//     String imagePath,
//     String svgPath,
//     double offsetX,
//     double offsetY,
//   ) {
//     // ابتدا SVG رو لود می‌کنیم
//     final svg = SvgPicture.asset(svgPath);

//     // از طریق SVG مسیر رو استخراج می‌کنیم
//     final path = _getSvgPath(svg);

//     // حالا از مسیر و موقعیت تعیین‌شده استفاده می‌کنیم
//     return _applyMaskToImage(imagePath, path, offsetX, offsetY);
//   }

//   // این تابع مسیر‌های SVG رو از فایل می‌خونه و تبدیل به Path می‌کنه
//   static Path _getSvgPath(SvgPicture svg) {
//     // مسیر SVG رو از فایل استخراج می‌کنیم
//     // در اینجا فقط مثالی هست که باید با SVG خودتون تطبیق بدید
//     return Path(); // مسیر واقعی شما اینجا وارد میشه
//   }

//   // این تابع ماسک SVG رو به تصویر اصلی اعمال می‌کنه
//   static Image _applyMaskToImage(
//     String imagePath,
//     Path maskPath,
//     double offsetX,
//     double offsetY,
//   ) {
//     // برش تصویر با استفاده از ماسک و جابجایی
//     // (کدی برای اعمال ماسک روی تصویر اینجا قرار می‌گیره)
//     return Image.asset(imagePath);
//   }
// }
