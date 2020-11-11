// Copyright 2017 The Chromium Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//    * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//    * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';
import 'dart:convert';
import 'DatabaseSnapshot.dart';
import 'FirebaseWebUnofficialUtilities.dart';
import 'dart:js' as js;

const FUNCTION_PRELIMINARY = "flutterFirebaseDatabaseWeb_";
class Query {
  String path = "";
  List<Map<String, dynamic>> _modifiers = new List<Map<String, dynamic>>();

  /// Called by other functions to listen to the database
  Stream<DatabaseSnapshot> _observe(_EventType _eventType) {
    // ignore: close_sinks
    final streamController = StreamController<DatabaseSnapshot>();
    //Tell the callback dispatcher what to do when it gets a callback
    String callbackID = NativeJavascriptHandler.dispatcher.registerCallback((js.JsObject returnedObject) {
      //Add snapshot to stream sink
      streamController.sink.add(DatabaseSnapshot(returnedObject));
    });
    //Tell JavaScript library to start listening
    js.context.callMethod(FUNCTION_PRELIMINARY + "on", [path ==""? "/" : path, _eventType.toString().split('.').last, callbackID, json.encode(_modifiers) ]);
    return streamController.stream;
  }

  /// Listens for a single value event and then stops listening.
  Future<DatabaseSnapshot> once() async => await onValue.first;

  /// Fires when children are added.
  Stream<DatabaseSnapshot> get onChildAdded => _observe(_EventType.child_added);

  /// Fires when children are removed.
  Stream<DatabaseSnapshot> get onChildRemoved => _observe(_EventType.child_removed);

  /// Fires when children are changed.
  Stream<DatabaseSnapshot> get onChildChanged => _observe(_EventType.child_changed);

  /// Fires when children are moved.
  Stream<DatabaseSnapshot> get onChildMoved => _observe(_EventType.child_moved);

  /// Fires when the data at this location is updated.
  Stream<DatabaseSnapshot> get onValue => _observe(_EventType.value);


  /// Create a query constrained to only return child nodes with a value greater
  /// than or equal to the given value, using the given orderBy directive or
  /// priority as default, and optionally only child nodes with a key greater
  /// than or equal to the given key.
  Query startAt(dynamic value, {String key = ""}) {
    key == ""?  _modifiers.add({"type" : "startAt", "vals" : [value]}) : _modifiers.add({"type" : "startAt", "vals" : [value, key]});
    return this;
  }

  /// Create a query constrained to only return child nodes with a value less
  /// than or equal to the given value, using the given orderBy directive or
  /// priority as default, and optionally only child nodes with a key less
  /// than or equal to the given key.
  Query endAt(dynamic value, {String key = ""}) {
    key == ""?  _modifiers.add({"type" : "endAt", "vals" : [value]}) : _modifiers.add({"type" : "endAt", "vals" : [value, key]});
    return this;
  }

  /// Create a query constrained to only return child nodes with the given
  /// `value` (and `key`, if provided).
  ///
  /// If a key is provided, there is at most one such child as names are unique.
  Query equalTo(dynamic value, {String key = ""}) {
    key == ""?  _modifiers.add({"type" : "equalTo", "vals" : [value]}) : _modifiers.add({"type" : "equalTo", "vals" : [value, key]});
    return this;
  }

  /// Create a query with limit and anchor it to the start of the window.
  Query limitToFirst(int limit) {
    _modifiers.add({"type": "limitToFirst", "vals" : [limit]});
    return this;
  }

  /// Create a query with limit and anchor it to the end of the window.
  Query limitToLast(int limit) {
    _modifiers.add({"type": "limitToLast", "vals" : [limit]});
    return this;
  }

  ///
  /// The ordering does not work. JSON automatically gets sorted on web, so all the parsing would have to be handled manually.
  ///
  Query _orderByChild(String key) {
    _modifiers.add({"type": "orderByChild", "vals" : [key]});
    return this;
  }

  Query _orderByKey() {
    _modifiers.add({"type": "orderByKey"});
    return this;
  }

  Query _orderByPriority() {
    _modifiers.add({"type": "orderByPriority"});
    return this;
  }

  Query _orderByValue() {
    _modifiers.add({"type": "orderByValue"});
    return this;
  }
}

enum _EventType {
  value,
  child_added,
  child_removed,
  child_changed,
  child_moved,
}


