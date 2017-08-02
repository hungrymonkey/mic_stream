import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:mic_stream/mic_stream.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<StreamSubscription<dynamic>> _micStreamSubscription = <StreamSubscription<dynamic>>[];
  Uint16List _micChunk= null;
  @override
  initState() {
    super.initState();
    _micStreamSubscription.add(micEvents.listen((MicEvent e){
      setState((){
        _micChunk = e.audioData;
      });
    }));
  }




  @override
  void dispose() {
    super.dispose();
    for (var subscription in _micStreamSubscription) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running on: ${_micChunk.toString()}\n'),
        ),
      ),
    );
  }
}
