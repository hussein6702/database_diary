import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/diary.json');
  }

  Future<String> readDiaries() async {
    try {
      final file = await _localFile;
      if(!file.existsSync()){
        print('File Doesnt Exist:${file.absolute.path}');
        await writeDiaries('{"diaries":[]}');
      }
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("Error Reading Diaries: $e");
      return '';
    }
  }

  Future<File> writeDiaries(String diaries) async {
    final file = await _localFile;
    return file.writeAsString(diaries);
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
  List<Diary> diary;

  Database({
    required this.diary,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(
    diary: List<Diary>.from(json["diary"].map((x) => Diary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "diary": List<dynamic>.from(diary.map((x) => x.toJson())),
  };
}

class Diary {
  late String id,date,mode,note;

  Diary(this.id, this.date, this.mode, this.note); 

  factory Diary.fromJson(Map<String, dynamic> json) => Diary(
    json["id"],
    json["date"],
    json["mode"],
    json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "mode": mode,
    "note": note,
  };
}

class DiaryEdit{
  late String action;
  Diary diary;
  DiaryEdit(this.action, this.diary);
}