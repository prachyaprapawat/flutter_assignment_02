import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableToDo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Todo {
  int _id;
  String _title;
  bool _done;



  String get title => this._title;
  set title(String title) => this._title = title;
bool get done => this._done;
  set done(bool done) => this._done = done;



  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: _title,
      columnDone: done == true ? 1 : 0
    };
    if (_id != null) {
      map[columnId] = _id;
    }

    return map;
  }

  Todo({String subject}) {
    this._title = subject;
  }


  Todo.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "\todo.db";

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableToDo (
            $columnId integer primary key autoincrement,
            $columnTitle text not null,
            $columnDone integer not null
          )
        ''');
      },
    );
  }

  Future<Todo> insert(Todo todo) async {
    db.insert(tableToDo, todo.toMap());

    return todo;
  }

  Future<List<Todo>> getTodos() async {
    var data = await db.query(tableToDo, where: '$columnDone = 0');
    return data.map((d) => Todo.fromMap(d)).toList();
  }

  Future<List<Todo>> getEnds() async {
    var data = await db.query(tableToDo, where: '$columnDone = 1');
    return data.map((d) => Todo.fromMap(d)).toList();
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(
      tableToDo,
      columns: [columnId, columnTitle, columnDone],
      where: '$columnId = ?',
      whereArgs: [id],);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }


  Future setEnd(Todo todo) async {
    await db.update(
      tableToDo,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo._id],);
  }

  Future delete(int id) async {
    return await db.delete(tableToDo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future deleteEnd() async {
    await db.delete(
      tableToDo,
      where: '$columnDone = 1',);
  }

  Future close() async => db.close();
}
