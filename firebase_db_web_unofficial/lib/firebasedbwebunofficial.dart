library firebasedbwebunofficial;

import 'dart:convert';

import 'package:firebase_db_web_unofficial/FirebaseWebUnofficialUtilities.dart';
import 'package:firebase_db_web_unofficial/PushIDGenerator.dart';
import 'package:firebase_db_web_unofficial/Query.dart';
import 'dart:js' as js;

import 'DatabaseSnapshot.dart';

const FUNCTION_PRELIMINARY = "flutterFirebaseDatabaseWeb_";

class FirebaseDatabaseWeb {
  static FirebaseDatabaseWeb instance = FirebaseDatabaseWeb();

  DatabaseRef reference() => DatabaseRef("");

  void goOffline() => js.context.callMethod(FUNCTION_PRELIMINARY + "goOffline");

  void goOnline() => js.context.callMethod(FUNCTION_PRELIMINARY + "goOnline");
}

class DatabaseRef extends Query {
  String path;

  DatabaseRef(this.path) {
    super.path = this.path;
  }

  DatabaseRef reference() => this;

  String get key =>
      this.path.substring(this.path.lastIndexOf("/") + 1, path.length);

  DatabaseRef child(String path) => DatabaseRef(this.path + "/" + path);

  DatabaseRef parent() =>
      DatabaseRef(this.path.substring(0, this.path.lastIndexOf("/") - 1));

  DatabaseRef root() => DatabaseRef("");

  ///
  /// Writing stuff
  ///

  /// Takes whatever path you currently have and adds a random string after it.
  DatabaseRef push() =>
      DatabaseRef(this.path + "/" + PushIdGenerator.generatePushChildName());

  Future<void> remove() async => set(null);

  Future<void> set(dynamic value) async =>
      NativeJavascriptHandler.callAndWaitForFeedback("set",
          params: [this.path == "" ? "/" : this.path, jsonEncode(value)]);

  Future<void> update(dynamic value) async {
   return NativeJavascriptHandler.callAndWaitForFeedback("update",
        params: [this.path == "" ? "/" : this.path, jsonEncode(value)]);
  }

}



