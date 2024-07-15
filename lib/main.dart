import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MapApp());
}

class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrainInfoScreen(),
    );
  }
}

class TrainInfoScreen extends StatefulWidget {
  @override
  _TrainInfoScreenState createState() => _TrainInfoScreenState();
}

class _TrainInfoScreenState extends State<TrainInfoScreen> {
  // コントローラーとスケールファクタ
  TransformationController _transformationController = TransformationController();
  double _scaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarに戻るボタンと列車情報を表示
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('行き先: 新宿行き'),
            Text('発車時刻: 13:30'),
            Text('路線: G - 山手線'),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              Row(
                children: [
                  Text('駅名: 東京駅'),
                  SizedBox(width: 10),
                  Text('ホーム: 3番'),
                ],
              ),
          ],
        ),
      ),
      // メインのコンテンツ
      body: InteractiveViewer(
        transformationController: _transformationController,
        onInteractionUpdate: (details) {
          setState(() {
            _scaleFactor = details.scale;
          });
        },
        child: Stack(
          children: [
            // 地図部分
            Container(
              color: Colors.grey[200],
              child: Center(child: Text('地図がここに表示される')),
            ),
            // 現在位置を示す青い丸
            Positioned(
              left: 100,
              top: 200,
              child: Icon(Icons.navigation, color: Colors.blue),
            ),
            // 列車の図形
            Positioned(
              left: 50,
              top: 50,
              child: Row(
                children: List.generate(
                  10,
                  (index) => Container(
                    margin: EdgeInsets.all(2),
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[(index + 1) * 100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            // 乗車すべき位置にピンアイコン
            Positioned(
              left: 150,
              top: 50,
              child: _scaleFactor > 2.0
                  ? Icon(Icons.location_pin, color: Colors.blue)
                  : Icon(Icons.arrow_upward, color: Colors.yellow),
            ),
            // エスカレーター・階段などのアイコン
            Positioned(
              left: 200,
              top: 300,
              child: Icon(Icons.directions_walk),
            ),
            // 混雑度のグラデーション（例）
            Positioned(
              left: 50,
              top: 100,
              child: Container(
                width: 300,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey, Colors.red],
                    stops: [0.5, 1.0], // グラデーションの位置は様々に調整可能
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}