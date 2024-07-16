import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Transfer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrainMapScreen(),
    );
  }
}

class TrainMapScreen extends StatefulWidget {
  @override
  _TrainMapScreenState createState() => _TrainMapScreenState();
}

class _TrainMapScreenState extends State<TrainMapScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final carriageSpacing = 4.0; // 半分の間隔
    final totalSpacing = carriageSpacing * 9; // 車両間の合計間隔
    final sidePadding = 10.0; // 左右の余白
    final availableWidth = screenWidth - (sidePadding * 2) - totalSpacing; // 使用可能な幅
    final carriageWidth = availableWidth / 10; // 各車両の幅
    final carriageHeight = 20.0;

    // 車両全体の幅を計算
    final totalCarriageWidth = (carriageWidth * 10) + (carriageSpacing * 9);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 53, 23, 221),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action
          },
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('行先: ○○駅'),
            SizedBox(width: 8),
            Text('08:30 発'),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'AL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(20.0),
        minScale: 0.5,
        maxScale: 4.0,
        child: Stack(
          children: [
            // Train carriages with connected gradient
            Positioned(
              top: 50,
              left: sidePadding,
              child: CustomPaint(
                size: Size(totalCarriageWidth, carriageHeight),
                painter: CarriagePainter(carriageWidth, carriageSpacing),
              ),
            ),
            // Current position
            Positioned(
              top: 50 + carriageHeight - 20, // 車両の位置 + 車両の高さ - ピンを20px上に移動
              left: sidePadding + 2 * (carriageWidth + carriageSpacing) + carriageWidth / 2 - 20, // 左余白 + 2番目の車両の位置 - ピンを20px上に移動
              child: Icon(
                Icons.navigation,
                color: Colors.blue,
                size: 40,
              ),
            ),
            // Map and Pins
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              bottom: 20,
              child: CustomPaint(
                painter: MapPainter(),
              ),
            ),
            // Pin icon (position adjusted to be on one of the carriages)
            Positioned(
              top: 50 - 20, // 車両の位置 - ピンを20px上に移動
              left: sidePadding + 2 * (carriageWidth + carriageSpacing) + carriageWidth / 2 - 20, // 左余白 + 2番目の車両の位置 - ピン中央
              child: Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 40,
              ),
            ),
            // Escalator/Stairs icons
            Positioned(
              top: 200,
              left: 50,
              child: SvgPicture.asset(
                'assets/escalator.svg',
                width: 40,
                height: 40,
              ),
            ),
            Positioned(
              top: 200,
              right: 50,
              child: SvgPicture.asset(
                'assets/stairs.svg',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarriagePainter extends CustomPainter {
  final double carriageWidth;
  final double carriageSpacing;

  CarriagePainter(this.carriageWidth, this.carriageSpacing);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [Colors.grey[300]!, Colors.red],
      stops: [0.3, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    double left = 0.0;
    double height = 20.0;

    for (int i = 0; i < 10; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(left, 0, carriageWidth, height), Radius.circular(4)),
        paint,
      );
      left += carriageWidth + carriageSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300] ?? Colors.grey
      ..style = PaintingStyle.fill;

    // Draw map background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}