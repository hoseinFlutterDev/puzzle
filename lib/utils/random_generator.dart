import 'dart:math';

class RandomGenerator {
  // تولید عدد تصادفی بین min و max
  static int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }

  // انتخاب تصادفی یک فایل SVG از لیست
  static String getRandomSVG() {
    final List<String> svgFiles = [
      'assets/svg/shape1.svg',
      'assets/svg/shape2.svg',
      'assets/svg/shape3.svg',
      'assets/svg/shape4.svg',
      'assets/svg/shape5.svg',
      'assets/svg/shape6.svg',
    ];

    final random = Random();
    return svgFiles[random.nextInt(svgFiles.length)];
  }
}
