import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:fft/fft.dart';
import 'package:my_complex/my_complex.dart';


class Utils{
  static Uint16List covertByte2Short(Uint8List audio){
    Uint16List result = new Uint16List((audio.length/2).floor());
    for(var i = 0; i < audio.length/2; i++){
      result[i] = (audio[i*2+1] & 0xFF) << 8 | (audio[i*2] & 0xFF);
    }
    return result;
  }
  static log10(num x) => log(x)/log(10);
  static log2(num x) => log(x)/log(2);
  static num avg(List<num> l) => l.fold(0, (p,n) => p+n)/l.length;

  static Float64List analyzeAudio(Uint16List audioFrag){
    //int samples = audioFrag.length;
    //int samplingRate = 48000;
    Float64List audioFloats;

    //http://www.bitweenie.com/listings/fft-zero-padding/
    //https://dsp.stackexchange.com/questions/741/why-should-i-zero-pad-a-signal-before-taking-the-fourier-transform

    //zero pad audio to nearest power of 2
    num exp = (Utils.log2(audioFrag.length)+1).floor();
    audioFloats = new Float64List(pow(2, exp));
    num avgSignal = avg(audioFrag);
    for(var i = 0; i < audioFrag.length;  i++) {
      audioFloats[i] = (audioFrag[i].toDouble()-avgSignal)/32768.0;
    }

    var windowed = new Window(WindowType.HAMMING).apply(audioFloats);
    var complexes = new FFT().Transform(windowed);
    Float64List magnitude = new Float64List(complexes.length);
    for(var i = 0; i < complexes.length; i++){
      Complex c = complexes[i];
      magnitude[i] = 10.0 * log10(sqrt(c.real*c.real + c.imaginary * c.imaginary));
    }
    return magnitude;
  }


}