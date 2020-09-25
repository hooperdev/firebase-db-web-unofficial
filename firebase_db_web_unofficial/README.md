# Firebase Database Web Unofficial

Firebase Database for flutter web apps. (UNOFFICIAL)

## Disclaimer

This is <b>NOT</b> official in any way shape or form. Dayton Square Roots and its developers are not affiliated with, nor endorsed by Google, Firebase, Flutter, or any other Google associations. This is a temporary solution until an official library is released.
<br>
Additional note: Sorting data is not yet suppported. Due to the way that most browsers process JSON data, sorting is impossible. We're currently working on ways to get around this, and will update the code and this readme when we have overcome this limitation.

## Installing

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:

  firebase_db_web_unofficial: ^0.0.1
```

<br>

And the following to your `web/index.html` file:

```html
  <script src="https://api.daytonsquareroots.org/firebasedatabaseweb/jsclient.js" defer></script>
```

Alternatively, download the app.js file from [GitHub](https://github.com/DaytonSquareRoots/APIs/blob/master/firebasedatabaseweb/jsclient.js), load it into your project, and reference it from your code.

<br>

Finally, follow the steps outlined in the [Firebase Console](https://console.firebase.google.com) for traditional Firebase Database web setup.
<br>

## Getting Started

This package has been designed to mimick the Firebase Database package which only works on iOS and Android as of 9/25/2020. To begin, call

```dart
    DatabaseRef ref = FirebaseDatabaseWeb.instance.reference();
```

<br>

The `DatabaseRef` object has multiple methods, which can be explored assuming you're using any modern IDE, which, considering that you're using Flutter, I sure hope you are.

<br>

## Privacy Concerns

Given that this is a database we're talking about here, user information is prone to be exposed to the source code. FlutterFirebaseDatabaseWebUnofficial code does not make any logs, external requests, or disclose any information it processes from your database. The code processes the information it recieves 100% client side, and never discloses any of it anywhere else. That said, Dayton Square Roots, and its developers are not responsible for any lost, malformed, stolen, or tampered-with data.

## Additional links

[Firebase Database Flutter Official(iOS and Android only)](https://pub.dev/packages/firebase_database)