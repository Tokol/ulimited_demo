import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unlimted_demo/data/call_log_task.dart';
import 'package:unlimted_demo/data/contact_task.dart';
import 'package:unlimted_demo/data/todo_task.dart';
import 'package:unlimted_demo/screen/bottom_screens/call_screen.dart';
import 'package:unlimted_demo/utils/constants.dart';


import 'bottom_screens/contact_screen.dart';
import 'bottom_screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  void changeBottomNavigationFromDrawer(int position){
    final BottomNavigationBar navigationBar = globalKey.currentWidget;
    navigationBar.onTap(position);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoTask>(
        create: (context) => TodoTask(),

        child: Scaffold(
          appBar: AppBar(title: Text(kAppTitle)),
          body: renderScreen(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    kAppTitle,
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text(kOptionTodo),
                  onTap: () {
                    Navigator.pop(context);
                    changeBottomNavigationFromDrawer(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_phone),
                  title: Text(kOptionContact),
                  onTap: () {
                    Navigator.pop(context);
                    changeBottomNavigationFromDrawer(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.call),
                  title: Text(kOptionCall),
                  onTap: () {
                    Navigator.pop(context);
                    changeBottomNavigationFromDrawer(2);
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            key: globalKey,

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: kOptionTodo,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone),
                label: kOptionContact,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: kOptionCall,
              ),
            ],
            currentIndex: _currentPage,
            selectedItemColor: Colors.blue[800],
            onTap: (position) {
              setState(() {
                _currentPage = position;
              });
            },
          ),
        ));
  }

  Widget renderScreen() {
    switch (_currentPage) {
      case 0:
        return ChangeNotifierProvider<TodoTask>(
          create: (context) => TodoTask(),
          child: TodoScreen(),
        );

      case 1:

        return ChangeNotifierProvider<ContactTask>(
          create: (context) => ContactTask(),
          child: ContactScreen(),
        );


      case 2:
        return ChangeNotifierProvider<CallLogTask>(
          create: (context) => CallLogTask(),
          child: CallScreen(),
        );

        break;

      default:
        return ChangeNotifierProvider<TodoTask>(
          create: (context) => TodoTask(),
          child: TodoScreen(),
        );
    }
  }
}
