import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';


const EventChannel _recordEventChannel =
const EventChannel('com.yourcompany.micstream/record');
class MicEvent {
  Uint16List audioData;
}

Stream<MicEvent> _micEvents;
Stream<MicEvent> get micEvents {
  if (_micEvents == null) {
    _micEvents = _recordEventChannel
        .receiveBroadcastStream();
  }
  return _micEvents;
}