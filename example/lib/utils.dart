import 'dart:core';
import 'dart:typed_data';

class Utils {
  static num argmin(Float64List data){
    num minIdx = -1;
    num minVal = double.INFINITY;
    for(var i = 0; i < data.length; i++){
      if(data[i] < minVal ){
        minIdx = i;
        minVal = data[i];
      }
    }
    return minIdx;
  }
  static num argmax(Float64List data){
    num maxIdx = -1;
    num maxVal = double.NEGATIVE_INFINITY;
    for(var i = 0; i < data.length; i++){
      if(data[i] > maxVal ){
        maxIdx = i;
        maxVal = data[i];
      }
    }
    return maxIdx;
  }
  static double index2Freq(int i, double samplesRate, int nFFT){
    //nFFt size of fft vector
    //number of samplesRate
    //index i
    return i.toDouble() * (samplesRate / nFFT.toDouble());
  }

}
