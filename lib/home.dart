import 'package:flutter/material.dart';
import 'edit_entry.dart';
import 'database.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database _database;
  Future<List<Diary>> _loadDiary() async {
    await DatabaseFileRoutines().readDiaries().then((diariesJson) {
      _database = databaseFromJson(diariesJson);
      _database.diary.sort(
        (comp1, comp2) =>
            DateTime.parse(comp2.date).compareTo(DateTime.parse(comp1.date)),
      );
    });
    return _database.diary;
  }


void _addOrEditDiary({
  required bool add,
  required int index,
  required Diary diary,

}) async {
  DiaryEdit _diaryEdit = DiaryEdit('', diary);
  _diaryEdit = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          EditEntry(add: add, index: index, diaryEdit: _diaryEdit),
      fullscreenDialog: true,
    ),
  );
  switch (_diaryEdit.action) {
    case 'Save':
      if (add) {
        setState(() {
          _database.diary.add(_diaryEdit.diary);
        });
      } else {
        setState(() {
          _database.diary[index] = _diaryEdit.diary;
        });
      }
      DatabaseFileRoutines().writeDiaries(databaseToJson(_database));
      break;
    case 'Cancel':
      break;
    default:
      break;
  }
}

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        String _titleDate = DateFormat.yMMMd().format(DateTime.parse(snapshot.data[index].date));
        String _subtitle = snapshot.data[index].mode + '\n ' + snapshot.data[index].note;
        return Dismissible(
          key: Key(snapshot.data[index].id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(24),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(24),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: Column(
              children: [
                Text(DateFormat.d().format(DateTime.parse(snapshot.data[index].date)), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                Text(DateFormat.E().format(DateTime.parse(snapshot.data[index].date)),),
              ],
            ),
            title: Text(_titleDate, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_subtitle,),
            onTap: () {
              _addOrEditDiary(add: false, index: index, diary: snapshot.data[index]);
            },
          ),
          onDismissed: (direction) {
            setState(() {
              _database.diary.removeAt(index);
            });
            DatabaseFileRoutines().writeDiaries(databaseToJson(_database));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Colors.blueGrey, thickness: 3.0);
      },
      itemCount: snapshot.data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        initialData: [],
        future: _loadDiary(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : _buildListView(snapshot);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(padding: const EdgeInsets.all(30.0)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Diary Entry',
        onPressed: () {
          _addOrEditDiary(add: true, index: -1, diary: Diary('',"",'',''));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

