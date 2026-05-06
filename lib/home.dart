import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(initialData: [],builder: (context, snapshot) {
        return snapshot.hasData ? Center(child: CircularProgressIndicator(),) : _buildListView(snapshot);
      }, future: _loadDiary(),)
    );
  }
  
 Widget _buildListView(AsyncSnapshot<List<dynamic>> snapshot) {

  }
}

Future<List<dynamic>>? _loadDiary() async {
}