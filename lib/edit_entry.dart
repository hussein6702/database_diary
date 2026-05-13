import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart'; 
import 'database.dart'; 
import 'dart:math'; 
 
class EditEntry extends StatefulWidget { 
  final bool add; 
  final int index; 
  final Diary diary; 
  const EditEntry({ 
    super.key, 
    required this.add, 
    required this.index, 
    required this.diary, 
  }); 
 
  @override 
  State<EditEntry> createState() => _EditEntryState(); 
} 
 
class _EditEntryState extends State<EditEntry> { 
  late DiaryEdit _diaryEdit; 
  late String _title; 
  late DateTime _selectedDate; 
  TextEditingController _noteController = TextEditingController(); 
  TextEditingController _moodController = TextEditingController(); 
  FocusNode _noteFocusNode = FocusNode(); 
  FocusNode _moodFocusNode = FocusNode(); 
 
  @override 
  void initState(){ 
    super.initState(); 
    _diaryEdit = DiaryEdit('Cancel', widget.diary); 
    _title = widget.add ? 'Add Diary Entry' : 'Edit Diary Entry'; 
    _diaryEdit.diary = widget.diary; 
    if(widget.add){ 
      _selectedDate = DateTime.now(); 
      _moodController.text = ''; 
      _noteController.text = ''; 
    } else { 
      _selectedDate = DateTime.parse(_diaryEdit.diary.date); 
      _moodController.text = _diaryEdit.diary.mood; 
      _noteController.text = _diaryEdit.diary.note; 
    } 
  } 
  @override 
  dispose() { 
    _moodController.dispose(); 
    _noteController.dispose(); 
    _moodFocusNode.dispose(); 
    super.dispose(); 
  } 
 
  Future<DateTime> _selectDate(DateTime selectedDate) async { 
    DateTime _initialDate = selectedDate; 
    final DateTime? pickedDate = await showDatePicker( 
      context: context,  
      initialDate: _initialDate, 
      firstDate: DateTime.now().subtract(Duration(days: 365)),  
      lastDate: DateTime.now().add(Duration(days: 365)), 
    ); 
 
    if(pickedDate != null) { 
      selectedDate = DateTime(pickedDate.year, pickedDate.month, 
        pickedDate.day, 
        _initialDate.hour,  
        _initialDate.minute,  
        _initialDate.second,  
        _initialDate.millisecond,  
        _initialDate.microsecond 
      ); 
    }
    return selectedDate;
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text(_title), 
      ), 
 
      body: SafeArea( 
        child: SingleChildScrollView( 
          padding: EdgeInsets.all(24.0), 
          child: Column( 
            children: [ 
              ElevatedButton( 
                onPressed: () async { 
                  FocusScope.of(context).requestFocus(FocusNode()); 
                  DateTime _pickerDate = await _selectDate(_selectedDate); 
                  setState(() { 
                    _selectedDate = _pickerDate; 
                  }); 
                },  
                 
                child: Row( 
                  children: [ 
                    Icon(Icons.calendar_today, size: 24.0, color: Colors.black,), 
                    Text(DateFormat.yMMMEd().format(_selectedDate), 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
                    ), 
                    Icon(Icons.arrow_drop_down, size: 24.0, color: Colors.black,) 
                  ], 
                ) 
              ), 
               
              TextField( 
                controller: _moodController, 
                autofocus: true, 
                textInputAction: TextInputAction.next, 
                focusNode: _moodFocusNode, 
                textCapitalization: TextCapitalization.words, 
                decoration: InputDecoration( 
                  labelText: 'Mood', 
                  icon: Icon(Icons.mood) 
                ), 
                onSubmitted: (submitted) { 
                  FocusScope.of(context).requestFocus(_noteFocusNode); 
                }, 
              ), 
              TextField(
                controller: _noteController,
                textInputAction: TextInputAction.newline,
                focusNode: _noteFocusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Note',
                  icon: Icon(Icons.note)
                ),
              ), 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _diaryEdit.action = 'Cancel';
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      _diaryEdit.action = 'Save';
                      String _id = widget.add ? Random().nextInt(999999999).toString() : _diaryEdit.diary.id;
                      String _date = DateFormat.yMd().format(_selectedDate);

                      _diaryEdit.diary = Diary(
                        _id,
                        _date,
                        _moodController.text,
                        _noteController.text,
                      );
                      Navigator.pop(context, _diaryEdit);               
                     },
                    child: Text('Save'),
                  ),
                ],
              ),
            ], 
          ), 
        ) 
      ), 
    ); 
  } 
}