import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unlimted_demo/data/todo_task.dart';
import 'package:unlimted_demo/model/todo.dart';
import 'package:unlimted_demo/utils/constants.dart';
import 'package:unlimted_demo/widget/task_tile.dart';
import 'package:unlimted_demo/widget/todo_text.dart';


class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoTask>(builder: (context, data, child) {
      return FutureBuilder<List<TODO>>(
          future: data.getAllTask(),
          builder: (BuildContext context, AsyncSnapshot<List<TODO>> snapshot) {

            if (snapshot.hasData) {
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.assignment),
                          text: kTabTitleAll,
                        ),
                        Tab(
                          icon: Icon(Icons.today),
                          text: kTabTitleToday,
                        ),
                        Tab(
                          icon: Icon(Icons.calendar_today_sharp),
                          text: kTabTitleTomorrow,
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      renderTask(TaskDate.all),
                      renderTask(TaskDate.today),
                      renderTask(TaskDate.tomorrow),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    elevation: 5.0,
                    child: Icon(Icons.add),
                    onPressed: () async {
                      await addTask(context);
                    },
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(kLoading),
              );
            }
            return Center(
              child: Text(kNoDataFound),
            );
          });
    });
  }

  Widget renderTask(TaskDate taskDate) {
    final _todoTask = Provider.of<TodoTask>(context, listen: false);
    List<TODO> todoList = _todoTask.getAllTaskFiltered(taskDate);
        if(todoList==null){
          return Container(
            child: Center(child: Text(kNoDataAdded),),
          );
        }

    return ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, position) {
          return TaskTile(
            task: todoList[position].task,
            date: todoList[position].date,
            onDelete: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(kSureDeleteTitle),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(kSureDeleDesc),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(kOptionNo),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(kOptionYes),
                        onPressed: () async {
                          await _todoTask.deleteToDo(todoList[position].id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            onUpdate: () async {
              await updateTask(context, todoList[position]);
            },
          );
        });
  }

  void addTask(BuildContext context) async {
    TODO _todo = TODO();
    final _todoTask = Provider.of<TodoTask>(context, listen: false);

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _todo.date = (formatter.format(now)).toString();
    String errorMsg = "";
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      TodoTextField(
                        hintValue: 'Task',
                        onChanged: (value) {
                          _todo.task = value;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1995, 1, 1),
                              maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            state(() {
                              _todo.date = (formatter.format(date)).toString();
                            });
                          }, onConfirm: (date) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');

                            state(() {
                              _todo.date = (formatter.format(date)).toString();
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              border:
                                  Border.all(width: 0.8, color: Colors.black38),
                            ),
                            child: Text(
                              _todo.date,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 10
                            : 300,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_todo.task != null) {
                            if (_todo.task.length > 0) {
                              _todoTask.insertTodo(_todo);
                              Navigator.pop(context);
                            } else {
                              state(() {
                                errorMsg = kErrorMessageEmpty;
                              });
                            }
                          } else {
                            state(() {
                              errorMsg = kErrorMessageEmpty;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(
                                  width: 0.8, color: Colors.black38)),
                          child: Text(
                            kTitleSave,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(child: Text(errorMsg)),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void updateTask(BuildContext context, TODO todo) async {
    TODO _todo = TODO();
    _todo.id = todo.id;
    _todo.task = todo.task;
    _todo.date = todo.date;

    final _todoTask = Provider.of<TodoTask>(context, listen: false);
    String errorMsg = "";
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      TodoTextField(
                        hintValue: _todo.task,
                        onChanged: (value) {
                          _todo.task = value;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1995, 1, 1),
                              maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            state(() {
                              _todo.date = (formatter.format(date)).toString();
                            });
                          }, onConfirm: (date) {
                            DateFormat formatter = DateFormat('yyyy-MM-dd');

                            state(() {
                              _todo.date = (formatter.format(date)).toString();
                            });
                          },
                              currentTime: DateTime.parse(_todo.date),
                              locale: LocaleType.en);
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              border:
                                  Border.all(width: 0.8, color: Colors.black38),
                            ),
                            child: Text(
                              _todo.date,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 10
                            : 300,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_todo.task != null) {
                            if (_todo.task.length > 0) {
                              _todoTask.updateToDo(_todo);
                              Navigator.pop(context);
                            } else {
                              state(() {
                                errorMsg = kErrorMessageEmpty;
                              });
                            }
                          } else {
                            state(() {
                              errorMsg = kErrorMessageEmpty;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(
                                  width: 0.8, color: Colors.black38)),
                          child: Text(
                            kTitleUpdate,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(child: Text(errorMsg)),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
