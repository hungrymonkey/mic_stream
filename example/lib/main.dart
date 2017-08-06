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
  List<int> _micClip = null;
  num _samples = 10000;
  FragmentPlayer _fPlayer;
  num _counter;
  @override
  initState() {
    super.initState();
    _fPlayer = new FragmentPlayer();
    _counter = 0;
    _micClip = new List();
    _micStreamSubscription.add(micEvents.listen((MicEvent e){
      setState((){
        _micAudioFragment = e.audioData;

        if(_counter < _samples) {
            _micClip.addAll(_micAudioFragment);
          _counter++;
        }
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
                    new IconButton(icon: new Icon(Icons.play_arrow),
                        onPressed: (){ _fPlayer.play(new Uint16List.fromList(_micClip));}),
                    new IconButton(icon: new Icon(Icons.stop),
                        onPressed: (){
                          setState(() {
                            _fPlayer.stop();
                            _micClip.clear();
                            _counter = 0;
                          }
                          );
                        }),
                  ],
              ),
              new Text('Mic samples saved: ${_counter}\n'
                 'only saves up to ${_samples} and the stop but reset the samples '
                  'saved'),
            ],
          ),
        ),
      ),
    );
  }
}
