import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:mic_stream/mic_stream.dart';

import './fragment_player.dart';
import './utils.dart';
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
  Float64List _freqDomain = null;
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
    _micAudioFragment = new Uint16List(0);
    _micStreamSubscription.add(micEvents.listen((MicEvent e){
      setState((){
        _micAudioFragment = e.audioData;
        _freqDomain = e.frequencyDomain;
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
    String _maxF = 'Max N/A';
    String _minF = 'Min N/A';
    if(_freqDomain != null) {
      final num _minIdx = Utils.argmin(_freqDomain);
      final num _maxIdx = Utils.argmax(_freqDomain);
      _maxF = 'Min Freq: ${Utils.index2Freq(_minIdx, 48000.0, _freqDomain.length)} db: ${_freqDomain[_minIdx]}';
      _minF = 'Max Freq: ${Utils.index2Freq(_maxIdx, 48000.0, _freqDomain.length)} db: ${_freqDomain[_maxIdx]}';
    }
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
              new Text('Mic fragment size: ${_micAudioFragment.length}\n'),
              new Text('Number of frequncy bins: ${_freqDomain == null ? 0 : _freqDomain.length}\n'),
              new Text( _maxF ),
              new Text( _minF ),
            ],
          ),
        ),
      ),
    );
  }
}
