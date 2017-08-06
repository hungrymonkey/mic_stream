import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';


const EventChannel _recordEventChannel =
const EventChannel('com.yourcompany.micstream/record');
class MicEvent {
  final Uint16List audioData;
  MicEvent(this.audioData);
}
MicEvent _covertByte2Short(Uint8List audio){
  Uint16List result = new Uint16List((audio.length/2).floor());
  for(var i = 0; i < audio.length/2; i++){
    result[i] = (audio[i+1] & 0xFF) << 8 | (audio[i] & 0xFF);
  }
  return new MicEvent(result);
}
Stream<MicEvent> _micEvents;
Stream<MicEvent> get micEvents {
  if (_micEvents == null) {
    _micEvents = _recordEventChannel
        .receiveBroadcastStream()
        .map(_covertByte2Short);
  }
  return _micEvents;
}