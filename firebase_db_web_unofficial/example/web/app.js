///This is the same thing as https://api.daytonsquareroots.org/firebasedatabaseweb/jsclient.js.
function flutterFirebaseDatabaseWeb_on(ref, type, callbackID, modifications) {
   var query = firebase.database().ref(ref);
   JSON.parse(modifications).forEach(function (mod) {
      switch (mod.type) {
         case "startAt": if (mod.vals[1] != null) { query = query.startAt(mod.vals[0], mod.vals[1]) } else { query.startAt(mod.vals[0]) } break;
         case "endAt": if (mod.vals[1] != null) { query = query.endAt(mod.vals[0], mod.vals[1]) } else { query.endAt(mod.vals[0]) } break;

         case "equalTo": if (mod.vals[1] != null) { query = query.equalTo(mod.vals[0], mod.vals[1]) } else { query.equalTo(mod.vals[0]) } break;
         case "limitToFirst": query = query.limitToFirst(mod.vals[0]); break;
         case "limitToLast": query = query.limitToLast(mod.vals[0]); break;

         case "orderByChild": query = query.orderByChild(mod.vals[0]); break;
         case "orderByKey": query = query.orderByKey(); break;
         case "orderByPriority": query = query.orderByPriority(); break;
         case "orderByValue": query = query.orderByValue(); break;
      }
   });
   query.on(type, (snapshot) => flutterFirebaseDatabaseWeb_on_callback(snapshot, callbackID));
}

//Sends data back to Dart after a .on() call
function flutterFirebaseDatabaseWeb_on_callback(snapshot, callbackID) {
   //TODO: Make this not be so hungry processor-wise.
   //We have to sort it ourselves because json is stupid and it automatically sorts in a way that might not be desired.
   //var sortedJSON = FFDWcreateJSON(snapshot, callbackID);


   var obj = {
     // "value": sortedJSON,
     "value" : JSON.stringify(snapshot.val()),
      "key": snapshot.key
   };
   runFlutterFirebaseDatabaseWebDartCallback({ "callbackID": callbackID, "snapshot": obj });
}

function FFDWcreateJSON(snapshot, callbackID) {
   var base = new FFDWObject("", null, snapshot);
   return FFDWFindDeepestPoint(base, callbackID);
}

function FFDWFindDeepestPoint(object, callbackID) {
   if (object.hasChildren()) {
      var res = new FFDWStringJSON(callbackID);
      object.children().forEach(function (obj) {
         //This is where it gets screwed up. Do a custom String based json, and only decode it in dart.
         res.set(obj.key, FFDWFindDeepestPoint(obj, callbackID));
      });
      return res.json;
   }
   else {
      // It's surrounded in <$callbackID> since everything is going to be converted into a string.
      // So if the value happens to be JSON, it might get misinterpreted if not marked.
      // It uses the callbackID because there's already a 1 in 1,028,071,702,528 chance that some string might have it and screw things up, so no point in making another one.
      
      return "<"+callbackID+">" + object.value + "</"+callbackID+">";
   }
}

function FFDWObject(key, parent, snapshot) {
   this.isBase = parent == null;
   this.parent = parent;
   this.key = key;
   this.snapshot = snapshot;
   this.child = (childName) => new FFDWObject(childName, this, snapshot.child(childName));
   this.children = function () {
      var objects = [];
      snapshot.forEach(function (snap) {
         objects.push(new FFDWObject(String(snap.key), this, snap));
      });
      return objects;
   }
   this.hasChildren = () => snapshot.hasChildren();
   this.value = snapshot.val();
   this.getJSONStringRepresentation = function () {

   }
}

function FFDWStringJSON(callbackID) {
   this.json = '{}'
   this.set = function (key, value) {

      // Find the last bracket
      var insertAt = this.json.length - 1;
      // Get a substring which doesn't include the last bracket. It will be closed later.
      var insertableText = this.json.substring(0, insertAt);

      // Check to see if there are previous nodes, requiring the usage of a comma. 
      // We can't place a comma at the end of the insertion because dart doesn't like it :|
      // So just see if there's a colon.
      if (insertableText.includes(":")) {
         // Insert the comma, then key/value followed by the closing bracket.
         insertableText += ', "' + key + '" : ' + FFDWJsonValueFormat(value, callbackID) + "}";
      }
      else {
         // Insert the key/value followed by the closing bracket.
         insertableText += '"' + key + '" : ' + FFDWJsonValueFormat(value, callbackID) + "}";
      }

      this.json = insertableText;
   }
}

function FFDWJsonValueFormat(toFormat, callbackID) {
   //If it's a json, number, or array, leave it. If it's a string, surround it with quotes.
   
   if (FFDWisString(toFormat)) {
      //Check to see if it's actually a JSON.
      if (toFormat.includes("<"+ callbackID +">")) {
       return '"' + toFormat.replace("<"+ callbackID +">", "").replace("</"+callbackID+">", "") + '"';
      }
      else {
         return toFormat;

      }
   }
   else {
      return toFormat;
   }

}

function FFDWisString(str) {
   var alphabet = "abcdefghijklmnopqrstuvwxyz".split("");
   for(var char of str.split("")) {
      if(alphabet.includes(char.toLowerCase())) {return true;}
   }
   return false;
}


function flutterFirebaseDatabaseWeb_goOffline() {
   firebase.database().goOffline();
}

function flutterFirebaseDatabaseWeb_goOnline() {
   firebase.database().goOnline();
}

function flutterFirebaseDatabaseWeb_set(ref, value, callbackID) {
   console.log("ref:");
   console.log(ref);
   firebase.database().ref(ref).set(value).then(()=> {
      runFlutterFirebaseDatabaseWebDartCallback({ "callbackID": callbackID});
   });
}

window.logger = (flutter_value) => {
   console.log({ js_context: this, flutter_value });
}
