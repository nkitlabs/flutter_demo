import 'package:flutter/material.dart';
import 'prediction_widget.dart';
import 'package:demo/utils/constants.dart';
import 'package:demo/model/recognizer.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final canvasSize = Constants.canvasSize;
  final borderSize = Constants.borderSize;
  final strokeWidth = Constants.strokeWidth;
  final _recognizer = Recognizer();
  List<Prediction> _prediction;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digit Recognizer'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Align(alignment: Alignment.center, child: _drawCanvasWidget()),
          SizedBox(height: 10),
          PredictionWidget(predictions: _prediction),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Clear'),
        onPressed: () {
          setState(() {
            _points.clear();
            _prediction.clear();
          });
        },
      ),
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: canvasSize + borderSize * 2,
      height: canvasSize + borderSize * 2,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: borderSize)),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 0 &&
              _localPosition.dx <= canvasSize &&
              _localPosition.dy >= 0 &&
              _localPosition.dy <= canvasSize) {
            setState(() {
              _points.add(_localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(painter: DrawingPainter(_points)),
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter(this.points);

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.blue
    ..strokeWidth = Constants.strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
