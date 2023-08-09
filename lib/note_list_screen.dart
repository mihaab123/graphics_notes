import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_notes/line_model.dart';
import 'package:graphics_notes/note_edit_screen.dart';
import 'package:graphics_notes/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteListScreen extends StatefulWidget {
  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Box<NoteModel> pointsBox;
  @override
  void initState() {
    super.initState();
    pointsBox = Hive.box<NoteModel>('notes');
  }
  void _deletePoint(NoteModel point) {
    pointsBox.delete(point.key);
    setState(() {}); // Обновляем список после удаления
  }
  @override
  Widget build(BuildContext context) {
    // Здесь загрузите заметки из базы данных или откуда-либо еще
    List<Map<String, dynamic>> notes = [
      {'title': 'Note 1', 'paintImageData': [/* Image data */]},
      // ...
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note List'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<NoteModel>('notes'),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.done) {
            var noteBox = Hive.box<NoteModel>('notes');
            List<NoteModel> notes = noteBox.values.toList();
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index].title),
                leading: Image.memory(Uint8List.fromList(notes[index].paintImageData)),
                trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                  _deletePoint(notes[index]);
                },),
                onTap: () {
                  // Переход на экран редактирования заметки
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => NoteEditScreen(
                  //       initialTitle: notes[index].title,
                  //       initialPaintImageData: notes[index].paintImageData,
                  //       onSave:(){
                  //         setState(() {
                            
                  //         });
                  //       }
                  //     ),
                  //   ),
                  // );
                },
              );
            },
          );}else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Переход на экран создания новой заметки
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  NoteEditScreen(initialTitle: "",initialPaintImageData: [],onSave:(){
                          setState(() {
                            
                          });
                        })),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
