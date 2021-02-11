import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:unlimted_demo/model/todo.dart';

class DB {
  static Database _db;

  static int get _version => 1;

  static final String TABLE_NAME = "TODOS";

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'task';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    db.execute("CREATE TABLE '$TABLE_NAME' ("
        "id INTEGER PRIMARY KEY,"
        "taskName TEXT,"
        "date TEXT"
        ")");
  }

  static Future<int> insert(TODO todo) async {
    var table = await _db.rawQuery("SELECT MAX(id)+1 as id FROM $TABLE_NAME");
    int id = table.first["id"];

    var raw = await _db.rawInsert(
        "INSERT Into $TABLE_NAME (id,taskName,date)"
        " VALUES (?,?,?)",
        [id, todo.task, todo.date]);
    return raw;
  }

  static Future<List<TODO>> query() async {
    var res = await _db.query("$TABLE_NAME");
    List<TODO> _todoList = [];
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        _todoList.add(
            TODO(id: res[i]["id"], task: res[i]["taskName"], date: res[i]["date"]));
      }
    }

    return _todoList;
  }

  static Future<int> update(TODO todo) async {

    await _db.update('$TABLE_NAME', todo.toMap(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<int> delete(int id) async {
    await _db.delete('$TABLE_NAME', where: 'id = ?', whereArgs: [id]);
  }
}
