import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';
 
class DatabaseConnect {
  Database? = _database;

  Future<Database> get database async{

    final dbpath = await getDatabasesPath();

    const dbname = 'todo.db';
    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _detabase!; 
  } 

  Future <void> _createDB(Database db, int version) async{
    await db.execute('''
    CREATE TABLE todo(
      id INTEGER PRIMARY KEY AUTOINCREMENT ,
      tittle TEXT,
      desc TEXT,
      dateandtime TEXT
    )
    ''');
  }

  Future<void>inserttodo(Todo todo) async {
    
  }
}

