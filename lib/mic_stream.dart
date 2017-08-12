import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mic_stream/utils.dart';

const EventChannel _recordEventChannel =
  const EventChannel('com.yourcompany.micstream/record');
class MicEvent {
  final Uint16List audioData;
  final Float64List frequencyDomain;
  MicEvent(this.audioData, {this.frequencyDomain});
}

MicEvent _createEvent(Uint8List audio){
  return new MicEvent(Utils.covertByte2Short(audio));
}
MicEvent _createFFTEvent(Uint8List audio){
  var audioData = Utils.covertByte2Short(audio);
  return new MicEvent(audioData, frequencyDomain: Utils.analyzeAudio(audioData));
}
Stream<MicEvent> _micEvents;
Stream<MicEvent> get micEvents {
  if (_micEvents == null) {
    _micEvents = _recordEventChannel
        .receiveBroadcastStream()
        .map(_createEvent);
  }
  return _micEvents;
}
Stream<MicEvent> get micEventsFFT {
  if (_micEvents == null) {
    _micEvents = _recordEventChannel
        .receiveBroadcastStream()
        .map(_createFFTEvent);
  }
  return _micEvents;
}