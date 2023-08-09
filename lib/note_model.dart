// note_model.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late List<int> paintImageData;

  NoteModel(this.title, this.paintImageData);
}

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  NoteModel read(BinaryReader reader) {
    var name = reader.readString();
    var image = reader.readList();
    return NoteModel(
      name,
      List<int>.from(image),
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer.writeString(obj.title);
    writer.writeList(obj.paintImageData);
  }

  @override
  int get typeId => 0;
}
