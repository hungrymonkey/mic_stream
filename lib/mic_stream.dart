import 'dart:async';

import 'package:flutter/services.dart';

class MicStream {
  static const MethodChannel _channel =
      const MethodChannel('mic_stream');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
