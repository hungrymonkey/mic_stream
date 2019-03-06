# mic_stream

A Flutter plugin to access the mic fragments as Uint16List. Currently, android only

Master branch should work with flutter stable.

## Getting Started

To use this plugin, add mic_stream as a dependency in your [pubspec.yaml](https://flutter.io/using-packages/) file.

## Example
```
import 'package:mic_stream/mic_stream.dart';

micEvents.listen((MicEvent event) {
 // Do something with the event.
 event.audioData //<UInt16List>
});


micEventsFFT.listen((MicEvent event) {
 // Do something with the event.
 // I do not recommend the fft event because it is very slow
 event.audioData
 event.frequencyDomain //<Float64List>
});
```
