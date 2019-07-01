import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mic_stream/mic_stream.dart';

void main() {
  const MethodChannel channel = MethodChannel('mic_stream');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MicStream.platformVersion, '42');
  });
}
