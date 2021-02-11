import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unlimted_demo/data/contact_task.dart';
import 'package:unlimted_demo/model/contact.dart';
import 'package:unlimted_demo/utils/constants.dart';
import 'package:unlimted_demo/widget/todo_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactTask>(
      builder: (context, data, child) {
        return FutureBuilder<List<ContactUser>>(
            future: data.getAllContacts(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ContactUser>> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  body: getContactDetailUi(snapshot.data),
                  floatingActionButton: FloatingActionButton(
                    elevation: 5.0,
                    child: Icon(Icons.add),
                    onPressed: () async {
                      await addContacts(context);
                      //await addTask(context);
                    },
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                Text(kLoading);
              }

              return Scaffold(
                body: Text(kNoDataFound),
                floatingActionButton: FloatingActionButton(
                  elevation: 5.0,
                  child: Icon(Icons.add),
                  onPressed: () async {
                    await addContacts(context);
                    //await addTask(context);
                  },
                ),
              );
            });
      },
    );
  }

  Widget getContactDetailUi(List<ContactUser> users) {
    if (users == null) {
      return Container(
        child: Center(
          child: Text(kNoContactAdded),
        ),
      );
    } else if (users.isEmpty) {
      return Container(
        child: Center(
          child: Text(kNoContactAdded),
        ),
      );
    }

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Card(
              child: Column(
                children: [
                  Text(
                    users[position].displayName,
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: getPhonesNumber(users[position].phoneNumber),
                  )
                ],
              ),
            ),
          );
        });
  }

  List<Widget> getPhonesNumber(List<String> numbers) {
    List<Widget> phonesNumbers = [];
    for (int i = 0; i < numbers.length; i++) {
      phonesNumbers.add(Row(
        children: [
          IconButton(
              icon: Icon(Icons.call),
              iconSize: 30.0,
              onPressed: () {
                launch("tel://${numbers[i]}");
              }),
          SizedBox(
            width: 10.0,
          ),
          Text(numbers[i],
              style: TextStyle(
                  color: Colors.black, fontSize: 15.0, letterSpacing: 1.3)),
        ],
      ));
    }
    return phonesNumbers;
  }

  void addContacts(BuildContext context) async {
    final _todoTask = Provider.of<ContactTask>(context, listen: false);

    String _phoneNumber = "";

    String _firstName = "";
    String _lastName = "";
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
                        hintValue: kFirstName,
                        keyboard: TextInputType.name,
                        onChanged: (value) {
                          _firstName = value;
                        },
                      ),
                      TodoTextField(
                        hintValue: kLastName,
                        keyboard: TextInputType.name,
                        onChanged: (value) {
                          _lastName = value;
                        },
                      ),
                      TodoTextField(
                        hintValue: kPhone,
                        keyboard: TextInputType.phone,
                        onChanged: (value) {
                          _phoneNumber = value;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 10
                            : 300,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_phoneNumber != null &&
                              _lastName != null &&
                              _firstName != null) {
                            if (_phoneNumber.length > 0 &&
                                _firstName.length > 0 &&
                                _lastName.length > 0) {
                              _todoTask.addNewContact(
                                  firstName: _firstName,
                                  lastName: _lastName,
                                  phoneNumber: _phoneNumber);
                              Navigator.pop(context);
                            } else {
                              state(() {
                                errorMsg = kErrorMessageEmptyContact;
                              });
                            }
                          } else {
                            state(() {
                              errorMsg = kErrorMessageEmptyContact;
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
}
