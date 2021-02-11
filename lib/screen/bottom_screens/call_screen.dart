import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unlimted_demo/data/call_log_task.dart';
import 'package:unlimted_demo/model/call_log.dart';
import 'dart:io' show Platform;

import 'package:unlimted_demo/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            kiosCallLog,
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
        ),
      );
    }

    return Consumer<CallLogTask>(builder: (context, data, child) {
      return FutureBuilder<List<PhoneCallLog>>(
          future: data.getCallLog(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PhoneCallLog>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, position) {
                    return Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 15,
                          child: Column(
                            children: [
                              snapshot.data[position].name != null
                                  ? Text(snapshot.data[position].name)
                                  : Text(snapshot.data[position].phoneNumber),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data[position].callType),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data[position].timeStamp),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.call),
                                      iconSize: 30.0,
                                      onPressed: () {
                                        launch(
                                            "tel://${snapshot.data[position].phoneNumber}");
                                      }),
                                  Text(snapshot.data[position].duration),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ));
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text(kLoading));
            }

            return Center(child: Text(kNoCallLog));
          });
    });
  }
}
