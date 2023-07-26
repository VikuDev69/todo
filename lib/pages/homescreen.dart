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
        duration: Duration(seconds: 1),
        backgroundColor: Colors.black,
        content: Text("Note Deleted :( ")));
    return _refreshData();
  }

  // Text Controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
// if id is not null then it will update other wise it will new data
// when edit icon is pressed then the id will be given to bottomsheet function
//and it will edit
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }
    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                right: 15,
                left: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Your Note"),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addData();
                        }
                        if (id != null) {
                          await _updateData(id);
                        }
                        _titleController.text = "";
                        _descController.text = "";
// It will hide bottom sheet

                        Navigator.of(context).pop();
                        print("data Added");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          id == null ? "Add Note" : "Update",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple.shade500,
          title: const Text(
            "Todo",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white60),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    tileColor: Colors.deepPurple.shade100,
                    splashColor: Colors.deepPurple,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['title'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Text(_allData[index]['desc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showBottomSheet(_allData[index]["id"]);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.deepPurple,
                            )),
                        IconButton(
                            onPressed: () {
                              _deleteData(_allData[index]['id']);
                              print("data Deleted");
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add",
          splashColor: Colors.deepPurple,
          onPressed: () => showBottomSheet(null),
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ));
  }
}
