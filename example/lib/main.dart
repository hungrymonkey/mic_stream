import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:mic_stream/mic_stream.dart';

import './fragment_player.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<StreamSubscription<dynamic>> _micStreamSubscription = <StreamSubscription<dynamic>>[];
  Uint16List _micAudioFragment= null;
  FragmentPlayer _fPlayer;
  int _counter;
  @override
  initState() {
    super.initState();
    _fPlayer = new FragmentPlayer();
    _counter = 0;
    _micStreamSubscription.add(micEvents.listen((MicEvent e){
      setState((){
        _micAudioFragment = e.audioData;
        //_fPlayer.stream(_micAudioFragment);
        _counter++;
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
          child: new Column(
            children: <Widget>[
              new Row(
                  children: <Widget>[
                    new IconButton(icon: new Icon(Icons.play_arrow), onPressed: (){_fPlayer.start();}),
                    new IconButton(icon: new Icon(Icons.stop), onPressed: (){_fPlayer.stop();}),
                  ],
              ),
              new Text('Running on: ${_micAudioFragment.toString()}\n'),
            ],
          ),
        ),
      ),
    );
  }
}
