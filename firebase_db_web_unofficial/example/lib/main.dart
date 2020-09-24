import 'dart:convert';

import 'package:firebase_db_web_unofficial/DatabaseSnapshot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';

void main() {
  runApp(MyApp());
}


// The default Flutter code, but using reading/writing with Firebase Code.

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void _incrementCounter() async {
    DatabaseSnapshot val = await FirebaseDatabaseWeb.instance.reference().child("test").child("counter").once();
    FirebaseDatabaseWeb.instance.reference().child("test").child("counter").set(val.value +1);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              stream: FirebaseDatabaseWeb.instance.reference().child("test").child("counter").onValue,
              builder: (context, snap) {
                if(snap.hasData) {
                  DatabaseSnapshot snapshot = snap.data;
                  return Text(snapshot.value.toString());
                }
                else {
                  return Text("0");
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
