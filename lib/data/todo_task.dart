import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unlimted_demo/data/todo_data.dart';
import 'package:unlimted_demo/model/todo.dart';


enum TaskDate { all, today, tomorrow }

class TodoTask extends ChangeNotifier {
  List<TODO> _todoList = [];

  List<TODO> getTodoList() {
    return _todoList;
  }

  void insertTodo(TODO todo) async {
    if (todo != null) {
      await DB.insert(todo);
      await getAllTask();
    }
  }

  Future<List<TODO>> getAllTask() async {
    _todoList = await DB.query();
    notifyListeners();
    return _todoList;
  }

  List<TODO> getAllTaskFiltered(TaskDate taskDate) {
    List<TODO> _todos = [];
    List<TODO> _filterTodos = [];

    if (_todoList.isNotEmpty) {
      _todos = _todoList;

      DateTime nowDate = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      for (int i = 0; i < _todos.length; i++) {
        if (taskDate == TaskDate.all) {
          _filterTodos.add(_todos[i]);
        } else if (taskDate == TaskDate.today) {
          var todayDate = formatter.format(nowDate);
          String todayDateString = todayDate.toString().trim();
          if (_todos[i].date.trim() == todayDateString) {
            _filterTodos.add(_todos[i]);
          }
        } else if (taskDate == TaskDate.tomorrow) {
          var tomorrow = nowDate.add(Duration(
            days: 1,
          ));
          var tomorrowDate = formatter.format(tomorrow);
          String tomorrowString = tomorrowDate.toString().trim();
          if (_todos[i].date.trim() == tomorrowString) {
            _filterTodos.add(_todos[i]);
          }
        }
      }
      return _filterTodos;
    }
  }

  void deleteToDo(int todoId) async {
        await DB.delete(todoId);
        notifyListeners();
  }

  void updateToDo(TODO todo) async {
    await DB.update(todo);
    notifyListeners();
  }

}
