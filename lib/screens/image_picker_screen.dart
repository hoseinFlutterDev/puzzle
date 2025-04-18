import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePuzzleApp extends StatefulWidget {
  const ImagePuzzleApp({Key? key}) : super(key: key);

  @override
  _ImagePuzzleAppState createState() => _ImagePuzzleAppState();
}

class _ImagePuzzleAppState extends State<ImagePuzzleApp>
    with SingleTickerProviderStateMixin {
  File? _imageFile;
  ui.Image? _loadedImage;
  List<Rect> _pieces = [];
  Rect? _removedPiece;
  Offset? _removedPieceOffset;
  List<Rect> _fakePieces = [];
  final Random _random = Random();
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final GlobalKey _puzzleKey = GlobalKey(); // برای گرفتن مکان دقیق قطعات

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //! انتخاب عکس از گالری
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _resetState();
      _imageFile = File(pickedFile.path);

      final data = await _imageFile!.readAsBytes();
      final codec = await ui.instantiateImageCodec(data);
      final frame = await codec.getNextFrame();

      setState(() {
        _loadedImage = frame.image;
        _generatePuzzlePieces(frame.image);
      });
    }
  }

  //! ست استیت
  void _resetState() {
    setState(() {
      _pieces.clear();
      _removedPiece = null;
      _removedPieceOffset = null;
      _fakePieces.clear();
      _loadedImage = null;
    });
  }

  //! ساخت تکه های پازل
  void _generatePuzzlePieces(ui.Image image) {
    const int rows = 7;
    const int cols = 7;

    final pieceWidth = image.width / cols;
    final pieceHeight = image.height / rows;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        _pieces.add(
          Rect.fromLTWH(
            col * pieceWidth,
            row * pieceHeight,
            pieceWidth,
            pieceHeight,
          ),
        );
      }
    }
  }

  //! کلیک روی قطعه و حذف دستی
  void _handleCanvasClick(Offset position) {
    final renderBox =
        _puzzleKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(
      position,
    ); // تبدیل به موقعیت محلی

    for (final piece in _pieces) {
      if (piece.contains(localPosition)) {
        setState(() {
          _removedPiece = piece;
          _removedPieceOffset = renderBox.localToGlobal(piece.topLeft);

          _pieces.remove(piece);

          // ساخت قطعات فیک برای انتخاب
          final fakePieces = <Rect>[];
          while (fakePieces.length < 5) {
            final fakeIndex = _random.nextInt(_pieces.length);
            final fakePiece = _pieces[fakeIndex];
            if (!fakePieces.contains(fakePiece) && fakePiece != piece) {
              fakePieces.add(fakePiece);
            }
          }

          _fakePieces = [...fakePieces, piece]..shuffle();

          // شروع انیمیشن انتقال قطعه
          _animation = Tween<Offset>(
            begin: _removedPieceOffset!,
            end: Offset(
              _removedPieceOffset!.dx,
              MediaQuery.of(context).size.height - 150,
            ),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
          _animationController.reset();
          _animationController.forward();
        });
        break;
      }
    }
  }

  //! بازگرداندن قطعه حذف شده
  void _handlePieceClick(Rect piece) {
    if (piece == _removedPiece) {
      setState(() {
        _pieces.add(_removedPiece!);
        _removedPiece = null;
        _removedPieceOffset = null;
        _fakePieces.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            children: [
              Expanded(child: _buildPuzzle()),
              const SizedBox(height: 220),
            ],
          ),
          _buildBottomPanel(),
          if (_removedPiece != null) _buildMovingPiece(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.image),
      ),
    );
  }

  //! ویجت پس‌زمینه
  Widget _buildBackground() {
    return Positioned.fill(
      child:
          _imageFile == null
              ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent.shade100,
                      Colors.blueAccent.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              )
              : Stack(
                children: [
                  Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                ],
              ),
    );
  }

  //! ویجت ساخت پازل
  Widget _buildPuzzle() {
    if (_loadedImage == null) {
      return _imageFile == null
          ? const Center(child: Text('هیچ عکسی انتخاب نشده است.'))
          : const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTapDown: (details) => _handleCanvasClick(details.globalPosition),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              key: _puzzleKey, // کلید برای گرفتن موقعیت دقیق
              decoration: BoxDecoration(
                color: const ui.Color.fromARGB(208, 0, 0, 0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: _loadedImage!.width.toDouble(),
                  height: _loadedImage!.height.toDouble(),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(
                          _loadedImage!.width.toDouble(),
                          _loadedImage!.height.toDouble(),
                        ),
                        painter: PuzzlePainter(
                          image: _loadedImage!,
                          pieces: _pieces,
                        ),
                      ),
                      if (_pieces.isEmpty)
                        const Center(
                          child: Text(
                            'پازل کامل شد!',
                            style: TextStyle(fontSize: 24, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //! ساخت پنل پایین
  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          color: const Color.fromARGB(255, 19, 13, 41),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'چالش پازل',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 33, 31, 49),
                ),
                child: _buildFakePieces(),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  //! ساخت قطعه متحرک
  Widget _buildMovingPiece() {
    if (_removedPiece == null || _removedPieceOffset == null) {
      return SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value.dy,
          left: _animation.value.dx,
          child: CustomPaint(
            painter: PuzzlePiecePainter(
              image: _loadedImage!,
              rect: _removedPiece!,
            ),
          ),
        );
      },
    );
  }

  //! ساخت قطعات فیک
  Widget _buildFakePieces() {
    if (_fakePieces.isEmpty) {
      return const Center(
        child: Text(
          'منتظر انتخاب عکس...',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(6),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: _fakePieces.length,
      itemBuilder: (context, index) {
        final piece = _fakePieces[index];
        return GestureDetector(
          onTap: () => _handlePieceClick(piece),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CustomPaint(
              painter: PuzzlePiecePainter(image: _loadedImage!, rect: piece),
            ),
          ),
        );
      },
    );
  }

  //! فوتر پایین صفحه
  Widget _buildFooter() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              'تمام',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 50),
          const Text(
            'پازل درست را انتخاب کنید',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24),
          ),
        ],
      ),
    );
  }
}

class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final List<Rect> pieces;

  PuzzlePainter({required this.image, required this.pieces});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (Rect rect in pieces) {
      canvas.drawImageRect(image, rect, rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PuzzlePiecePainter extends CustomPainter {
  final ui.Image image;
  final Rect rect;

  PuzzlePiecePainter({required this.image, required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      rect,
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
