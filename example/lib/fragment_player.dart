import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

enum PlayerState { stopped, playing, paused }

class FragmentPlayer{
  static const String FROG_CHANNEL = "com.yourcompany.flutter/audioFragmentPlayer";
  static const platform = const MethodChannel(FROG_CHANNEL);

  PlayerState _pState;

  FragmentPlayer(): _pState = PlayerState.stopped{
  }


  Future<Null> play(Uint16List fragments) async{
    if(_pState != PlayerState.playing) {
      //covert to byte list as limited by platform channels supported type
      // https://flutter.io/platform-channels/#codec
      Uint8List byteFrags = new Uint8List(fragments.length * 2);
      for (var i = 0; i < fragments.length; i++) {
        byteFrags[i*2] = (fragments[i] & 0xff);
        byteFrags[i*2 + 1] = ((fragments[i] >> 8) & 0xff);
      }

      final int result = await platform.invokeMethod('play', byteFrags);
      _pState = result == 1 ? PlayerState.playing : _pState;

    }
  }
  Future<Null> stop() async{
    if(_pState != PlayerState.stopped ) {
      final int result = await platform.invokeMethod('stop');
      _pState = result == 1 ? PlayerState.stopped : _pState;
    }
  }



}