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
            // Train carriages with gradient
            Positioned(
              top: 50,
              left: 50,
              right: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(10, (index) => Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[300]!, Colors.red],
                      stops: [0.3, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
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
            // Current position
            Positioned(
              top: 150,
              left: 100,
              child: Transform.rotate(
                angle: 0.0, // Rotate angle for direction
                child: Icon(
                  Icons.navigation,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
            // Pin icon (position adjusted to be on one of the carriages)
            Positioned(
              top: 50, 
              left: 110, 
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}