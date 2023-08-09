import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_notes/app_constants.dart';
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

    return SafeArea(
      child: Scaffold(

        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg app download.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
          child: FutureBuilder(
            future: Hive.openBox<NoteModel>('notes'),
            builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.done) {
                var noteBox = Hive.box<NoteModel>('notes');
                List<NoteModel> notes = noteBox.values.toList();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      ),
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/note mini.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // height: 300,
                    // width: 300,
                    child:Stack(
                      children: [
                        Image.memory(Uint8List.fromList(notes[index].paintImageData),fit: BoxFit.cover,),
                      Positioned(left: MediaQuery.of(context).size.width/6.5,child: Text(notes[index].title,style: AppConstants().textStyle,)),
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: IconButton(onPressed: () {
                          _deletePoint(notes[index]);
                        }, icon:  Icon(Icons.delete, color: AppConstants().secondColor),),
                      ),
                      ],
                    ),
                  );
                  // return ListTile(
                  //   title: Text(notes[index].title),
                  //   leading: Image.memory(Uint8List.fromList(notes[index].paintImageData)),
                  //   trailing: IconButton(
                  //   icon: const Icon(Icons.delete, color: Colors.grey),
                  //   onPressed: () {
                  //     _deletePoint(notes[index]);
                  //   },),
                  //   onTap: () {
                  //     // Переход на экран редактирования заметки
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //     builder: (context) => NoteEditScreen(
                  //     //       initialTitle: notes[index].title,
                  //     //       initialPaintImageData: notes[index].paintImageData,
                  //     //       onSave:(){
                  //     //         setState(() {
                                
                  //     //         });
                  //     //       }
                  //     //     ),
                  //     //   ),
                  //     // );
                  //   },
                  // );
                },
              );}else{
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
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
          child: Image.asset("assets/images/button.png"),
        ),
      ),
    );
  }
}
