import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DatabaseFileRoutine {
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/diary_b.json');
  }

  Future<String> readDiary() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeDiary('{"diaries": []}');
      }
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  Future<File> writeDiary(String json) async {
    final file = await _localFile;
    return file.writeAsString(json);
  }
}

Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class Database {
  List<Diary> diaries;
  Database({required this.diaries});
  factory Database.fromJson(Map<String, dynamic> json) => Database(
    diaries: List<Diary>.from(json["diaries"].map((x) => Diary.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "diaries": List<dynamic>.from(diaries.map((x) => x.toJson())),
  };
}

class Diary {
  String id, date, mood, note;
  Diary(this.id, this.date, this.mood, this.note);
  factory Diary.fromJson(Map<String, dynamic> json) =>
      Diary(json["id"], json["date"], json["mood"], json["note"]);
  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "mood": mood,
    "note": note,
  };
}

class DiaryEdit {
  String action;
  Diary diary;
  DiaryEdit(this.action, this.diary);
}
