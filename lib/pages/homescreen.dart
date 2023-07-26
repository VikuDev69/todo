import 'package:flutter/material.dart';
import 'package:todo/pages/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  // Get All Data From DataBase
  void _refreshData() async {
    final data = await SQLHelper.getData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  // Initial State Refresh
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Add Data
  Future<void> _addData() async {
    await SQLHelper.createData(_titleController.text, _descController.text);
    _refreshData();
  }

  // Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _titleController.text, _descController.text);
    return _refreshData();
  }

  // Delete Data
  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent, content: Text("Note Deleted :( ")));
    return _refreshData();
  }

  // Text Controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


  void showBottomSheet(int? id) async {
    if(id != null){
      final existingData = _allData.firstWhere((element) => element['id']==id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade200,
          title: Text("Notes"),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(onPressed: () => showBottomSheet(null),
          child: Icon(Icons.add,),
    );
  }
}
