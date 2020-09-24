// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

import 'dart:math';

/// Utility class for generating Firebase child node keys.
///
/// Since the Flutter plugin API is asynchronous, there's no way for us
/// to use the native SDK to generate the node key synchronously and we
/// have to do it ourselves if we want to be able to reference the
/// newly-created node synchronously.
///
/// This code is based on a Firebase blog post and ported to Dart.
/// https://firebase.googleblog.com/2015/02/the-2120-ways-to-ensure-unique_68.html
class PushIdGenerator {
  static const String PUSH_CHARS =
      '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';

  static final Random _random = Random();

  static int _lastPushTime;

  static final List<int> _lastRandChars = List<int>(12);

  static String generatePushChildName() {
    int now = DateTime.now().millisecondsSinceEpoch;
    final bool duplicateTime = (now == _lastPushTime);
    _lastPushTime = now;

    final List<String> timeStampChars = List<String>(8);
    for (int i = 7; i >= 0; i--) {
      timeStampChars[i] = PUSH_CHARS[now % 64];
      now = (now / 64).floor();
    }
    assert(now == 0);

    final StringBuffer result = StringBuffer(timeStampChars.join());

    if (!duplicateTime) {
      for (int i = 0; i < 12; i++) {
        _lastRandChars[i] = _random.nextInt(64);
      }
    } else {
      _incrementArray();
    }
    for (int i = 0; i < 12; i++) {
      result.write(PUSH_CHARS[_lastRandChars[i]]);
    }
    assert(result.length == 20);
    return result.toString();
  }

  static void _incrementArray() {
    for (int i = 11; i >= 0; i--) {
      if (_lastRandChars[i] != 63) {
        _lastRandChars[i] = _lastRandChars[i] + 1;
        return;
      }
      _lastRandChars[i] = 0;
    }
  }
}
