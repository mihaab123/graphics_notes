// Внутри FlutterPaint
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics_notes/line_model.dart';

class FlutterPaint extends StatefulWidget {
  final Key? key;
  final Color lineColor; // Добавьте это свойство
  final double lineWidth; // Добавьте это свойство

  FlutterPaint(
      {this.key, this.lineColor = Colors.black, required this.lineWidth})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FlutterPaintState();
}

class FlutterPaintState extends State<FlutterPaint> {
  List<LineModel> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          points.add(LineModel(
              details.localPosition, widget.lineColor, widget.lineWidth));
        });
      },
      onPanEnd: (_) {
        points.add(LineModel(Offset.zero, widget.lineColor, widget.lineWidth));
      },
      child: CustomPaint(
        painter: PaintCanvas(points), // Передача цвета
        size: Size.infinite,
      ),
    );
  }

  // Метод для экспорта изображения

  Future<List<int>> exportImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromPoints(const Offset(0, 0), const Offset(300, 300)));

    for (int i = 0; i < points.length - 1; i++) {
      Paint paint = Paint()
        ..color = points[i].lineColor // Использование переданного цвета
        ..strokeCap = StrokeCap.round
        ..strokeWidth = points[i].lineWidth;
      if (points[i].point != Offset.zero &&
          points[i + 1].point != Offset.zero) {
        canvas.drawLine(points[i].point, points[i + 1].point, paint);
      } else if (points[i].point != Offset.zero &&
          points[i + 1].point == Offset.zero) {
        canvas.drawPoints(PointMode.points, [points[i].point], paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(300, 300);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
    // return Uint8List.fromList(Uint8List.view(pngBytes!.buffer));
  }
}

// Внутри PaintCanvas
class PaintCanvas extends CustomPainter {
  final List<LineModel> points;

  PaintCanvas(this.points); // Передача цвета

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      Paint paint = Paint()
        ..color = points[i].lineColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = points[i].lineWidth;
      if (points[i].point != Offset.zero &&
          points[i + 1].point != Offset.zero) {
        canvas.drawLine(points[i].point, points[i + 1].point, paint);
      } else if (points[i].point != Offset.zero &&
          points[i + 1].point == Offset.zero) {
        canvas.drawPoints(PointMode.points, [points[i].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
