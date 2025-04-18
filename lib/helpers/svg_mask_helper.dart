// lib/helpers/svg_mask_helper.dart
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';

class SvgMaskHelper {
  static Future<Path> loadSvgPath(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final path = parseSvgPathData(_extractPathData(svgString));
    return path;
  }

  static String _extractPathData(String svg) {
    final pathStart = svg.indexOf('d="') + 3;
    final pathEnd = svg.indexOf('"', pathStart);
    return svg.substring(pathStart, pathEnd);
  }
}
