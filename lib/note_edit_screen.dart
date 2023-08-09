import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:graphics_notes/FlutterPaint.dart';
import 'package:graphics_notes/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteEditScreen extends StatefulWidget {
  final String initialTitle;
  final List<int> initialPaintImageData;
  final VoidCallback onSave;
  const NoteEditScreen(
      {super.key,
      required this.initialTitle,
      required this.initialPaintImageData,
      required this.onSave});
  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FlutterPaintState> _paintKey = GlobalKey();
  Color currentColor = Colors.black; // Текущий цвет по умолчанию
  double currentLineWidth = 5.0; // Текущий размер линии по умолчанию
  @override
  void initState() {
    super.initState();
    // _loadImage();
    _titleController.text = widget.initialTitle;
  }

  // Future<List<Offset>> _loadImage() async {
  //   if (widget.initialPaintImageData.isNotEmpty) {
  //     ui.Image image = await decodeImageFromList(
  //         Uint8List.fromList(widget.initialPaintImageData!));
  //     List<Offset> loadedPoints = [];

  //     final recorder = PictureRecorder();
  //     final canvas = Canvas(
  //         recorder,
  //         Rect.fromPoints(Offset(0, 0),
  //             Offset(image.width.toDouble(), image.height.toDouble())));

  //     canvas.drawImage(
  //         image, Offset.zero, Paint()); // Отрисовываем изображение на холсте

  //     final picture = recorder.endRecording();
  //     final img = await picture.toImage(image.width, image.height);
  //     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List byteList = byteData!.buffer.asUint8List();

  //     int width = image.width;
  //     int height = image.height;

  //     for (int y = 0; y < height; y++) {
  //       for (int x = 0; x < width; x++) {
  //         int pixelIndex = (y * width + x) * 4;
  //         int alpha = byteList[pixelIndex];
  //         if (alpha > 0) {
  //           loadedPoints.add(Offset(x.toDouble(), y.toDouble()));
  //         }
  //       }
  //     }

  //     return loadedPoints;
  //   }
  //   return [];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create/Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // Сохранение заметки
              String title = _titleController.text;
              List<int> paintImageData =
                  await _paintKey.currentState!.exportImage();
              var noteBox = Hive.box<NoteModel>('notes'); // Получаем Box
              var newNote = NoteModel(title, paintImageData);
              await noteBox.add(newNote); // Сохраняем заметку в Hive
              widget.onSave();
              // Сохраните title и paintImageData в базу данных или куда-либо еще
              Navigator.pop(context); // Вернуться на предыдущий экран
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Select color:'),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Select a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    currentColor = color;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      color: currentColor,
                    ),
                  ),
                ],
              ),
              Slider(
                value: currentLineWidth,
                min: 1,
                max: 10,
                onChanged: (newValue) {
                  setState(() {
                    currentLineWidth = newValue;
                  });
                },
                label: 'Line Width: $currentLineWidth',
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue)),
                height: 300,
                width: 300,
                child: FlutterPaint(
                  key: _paintKey,
                  lineColor: currentColor,
                  lineWidth: currentLineWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
