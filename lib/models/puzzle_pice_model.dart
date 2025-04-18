class PuzzlePiece {
  final int id; // شناسه یکتا برای هر قطعه پازل
  final String imagePath; // آدرس تصویر برای نمایش
  final String svgPath; // مسیر فایل SVG برای ماسک
  final double x; // مختصات x برای مکان قطعه در صفحه
  final double y; // مختصات y برای مکان قطعه در صفحه

  PuzzlePiece({
    required this.id,
    required this.imagePath,
    required this.svgPath,
    required this.x,
    required this.y,
  });
}
