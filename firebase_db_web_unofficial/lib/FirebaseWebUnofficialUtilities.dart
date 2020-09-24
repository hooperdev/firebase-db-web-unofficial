import 'dart:async';
import 'dart:math';
import 'dart:js' as js;

import 'package:flutter/cupertino.dart';

const FUNCTION_PRELIMINARY = "flutterFirebaseDatabaseWeb_";
class FBDBWUUtilities {
  static String makeJavascriptCallbackID() {
    String result = "";
    for (int i = 0; i < 7; i++) {
      Random random = new Random();
      int rand = random.nextInt(51);
      switch (rand) {
        case 0:
          result += "A";
          break;
        case 1:
          result += "B";
          break;
        case 2:
          result += "C";
          break;
        case 3:
          result += "D";
          break;
        case 4:
          result += "E";
          break;
        case 5:
          result += "F";
          break;
        case 6:
          result += "G";
          break;
        case 7:
          result += "H";
          break;
        case 8:
          result += "I";
          break;
        case 9:
          result += "J";
          break;
        case 10:
          result += "K";
          break;
        case 11:
          result += "L";
          break;
        case 12:
          result += "M";
          break;
        case 13:
          result += "N";
          break;
        case 14:
          result += "O";
          break;
        case 15:
          result += "P";
          break;
        case 16:
          result += "Q";
          break;
        case 17:
          result += "R";
          break;
        case 18:
          result += "S";
          break;
        case 19:
          result += "T";
          break;
        case 20:
          result += "U";
          break;
        case 21:
          result += "V";
          break;
        case 22:
          result += "W";
          break;
        case 23:
          result += "X";
          break;
        case 24:
          result += "Y";
          break;
        case 25:
          result += "Z";
          break;
        case 26:
          result += "a";
          break;
        case 27:
          result += "b";
          break;
        case 28:
          result += "c";
          break;
        case 29:
          result += "d";
          break;
        case 30:
          result += "e";
          break;
        case 31:
          result += "f";
          break;
        case 32:
          result += "g";
          break;
        case 33:
          result += "h";
          break;
        case 34:
          result += "i";
          break;
        case 35:
          result += "j";
          break;
        case 36:
          result += "k";
          break;
        case 37:
          result += "l";
          break;
        case 38:
          result += "m";
          break;
        case 39:
          result += "n";
          break;
        case 40:
          result += "o";
          break;
        case 41:
          result += "p";
          break;
        case 42:
          result += "q";
          break;
        case 43:
          result += "r";
          break;
        case 44:
          result += "s";
          break;
        case 45:
          result += "t";
          break;
        case 46:
          result += "u";
          break;
        case 47:
          result += "v";
          break;
        case 48:
          result += "w";
          break;
        case 49:
          result += "x";
          break;
        case 50:
          result += "y";
          break;
        case 51:
          result += "z";
          break;
        default:
          result += "0";
      }
    }
    return result;
  }
}


class NativeJavascriptHandler {
  static JavascriptCallbackDispatcher dispatcher = JavascriptCallbackDispatcher.instance;

  static Future<dynamic> callAndWaitForFeedback(String functionName, {List<dynamic> params}) async {

    //Use a stream, because futures are harder to dynamically build.
    final streamController = StreamController<dynamic>();
    String callbackID = dispatcher.registerCallback((data) {streamController.sink.add(data); streamController.close();});
    List<dynamic> parameters = new List<dynamic>();
    parameters.addAll(params);
    parameters.add(callbackID);
    js.context.callMethod(FUNCTION_PRELIMINARY + functionName, parameters);

    return streamController.stream.first;
  }
}

class JavascriptCallbackDispatcher {
  JavascriptCallbackDispatcher() {
    //Initialize Dart function for JavaScript functions to call
    js.context["runFlutterFirebaseDatabaseWebDartCallback"] = (js.JsObject params) => _runCallback(params);
  }
  static JavascriptCallbackDispatcher instance = JavascriptCallbackDispatcher();
  Map<String, Function> callbacks = new Map<String, Function>();


  String registerCallback(Function callback) {
    //Create some id
    String id = FBDBWUUtilities.makeJavascriptCallbackID();
    //Add callback
    callbacks[id] = callback;
    //return the id for future use.
    return id;
  }

  void deregisterCallback(String id) {
    //Remove callback
    callbacks.remove(id);
  }

  void _runCallback(js.JsObject params) {
    //Call the specified callback, which hopefully has been registered.
    if(callbacks.containsKey(params["callbackID"])) {
      //Call the function
      callbacks[params["callbackID"]].call(params);
    }
    else {
      //Throw error
      print("FlutterFirebaseDatabaseWebUnofficial error. Callback " + params["callbackID"] + " does not correspond with a registered callback");
    }
  }



}
