import 'dart:convert';

import 'package:firebase_db_web_unofficial/DatabaseSnapshot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Database Web Demo",
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            RaisedButton(
              padding: EdgeInsets.only(top: 5),
              child: Text('Prepare'),
              onPressed: () {
                FirebaseDatabaseWeb.instance
                    .reference()
                    .child("test")
                    .child("a")
                    .set("Click a button to change this to 'hello'");
                FirebaseDatabaseWeb.instance
                    .reference()
                    .child("test")
                    .child("b")
                    .set({
                  "1": "This will be",
                  "2": "hello world",
                  "3": "When you click the button"
                });
              },
            ),
            RaisedButton(
              padding: EdgeInsets.only(top: 5),
              child: Text('Set test/a = "hello"'),
              onPressed: () {
                FirebaseDatabaseWeb.instance
                    .reference()
                    .child("test")
                    .child("a")
                    .set("Hello");
              },
            ),
            RaisedButton(
              padding: EdgeInsets.only(top: 5),
              child: Text('Update test/b = {"1": "Hello", "2": "World!"}'),
              onPressed: () {
                FirebaseDatabaseWeb.instance
                    .reference()
                    .child("test")
                    .child("b")
                    .update({"1": "Hello,", "2": "World!"});
              },
            ),
            RaisedButton(
              padding: EdgeInsets.only(top: 5),
              child: Text('Print the value of test in console'),
              onPressed: () async {
                DatabaseSnapshot snap = await FirebaseDatabaseWeb.instance
                    .reference()
                    .child("test")
                    .once();
                print(snap.value);
              },
            )
          ],
        ),
      ),
    );
  }
}
