import 'dart:convert';
import 'dart:js' as js;

import 'package:firebase_db_web_unofficial/FirebaseWebUnofficialUtilities.dart';

class DatabaseSnapshot {
  js.JsObject object;
  dynamic _val;
  String _key;

  DatabaseSnapshot(js.JsObject object) {
    this.object = object;
    this._val = jsonDecode(object["snapshot"]["value"]);
    this._key = object["snapshot"]["key"];
  }

  dynamic get value => _val;
  dynamic get key => _key;
}