package com.yourcompany.micstream;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.media.AudioRecord;
import android.media.AudioRecord.OnRecordPositionUpdateListener;
import android.media.AudioFormat;
import android.media.MediaRecorder;
import android.util.Log;
import android.app.Activity;
/**
 * MicStreamPlugin
 */
public class MicStreamPlugin implements EventChannel.StreamHandler {
  /**
   * Plugin registration.
   */
  private static final String MIC_STREAM_CHANNEL = "com.yourcompany.micstream/record";
  public static void registerWith(Registrar registrar) {
    final EventChannel micChannel = new EventChannel(registrar.messenger(), MIC_STREAM_CHANNEL);
    micChannel.setStreamHandler(new MicStreamPlugin(
            registrar.activity()));
  }
  private final String LOG_TAG = "mic record";
  private AudioRecord mRecorder;
  private OnRecordPositionUpdateListener mListener;
  private int mInBufferSize;
  private int mSampleRate;
  private int mPeriodFrames;
  private short [] audioData;
  private int reads;
  private static int mFormat = AudioFormat.ENCODING_PCM_16BIT;
  private MicStreamPlugin(Activity activity){
    mRecorder = null;
    mSampleRate = 48000;
    mInBufferSize = AudioRecord.getMinBufferSize(mSampleRate, AudioFormat.CHANNEL_IN_MONO, mFormat);
    //https://stackoverflow.com/questions/15804903/android-dev-audiorecord-without-blocking-or-threads
    //require android 5
    mPeriodFrames = mInBufferSize / 2;
    audioData = new short [mPeriodFrames];
  }
  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {

    mRecorder = new AudioRecord(
            MediaRecorder.AudioSource.MIC,
            mSampleRate, AudioFormat.CHANNEL_IN_MONO,
            mFormat, mInBufferSize
    );

    mRecorder.setPositionNotificationPeriod(mPeriodFrames);

    mListener = createRecordListener(events);
    mRecorder.setRecordPositionUpdateListener(mListener);

    try {
      mRecorder.startRecording();
    } catch (IllegalStateException e) {
      Log.e(LOG_TAG, "record() failed");
    }
    reads = 0;
  }
  @Override
  public void onCancel(Object args) {
    if (mRecorder != null) {
      mRecorder.stop();
      mRecorder.release();
      mRecorder = null;
    }
  }
  OnRecordPositionUpdateListener createRecordListener(final EventChannel.EventSink events){
    return new OnRecordPositionUpdateListener(){
      public void onMarkerReached(AudioRecord recorder){
        int bytesOut = recorder.read(audioData,0,mInBufferSize);
        Log.e(LOG_TAG, "marker reached " + reads );
      }
      public void onPeriodicNotification(AudioRecord recorder){
        int shortOut = recorder.read(audioData,0,mInBufferSize);
        short[] audioValues = new short[audioData.length];
        //make a copy of values to pass
        for(int i = 0; i< shortOut; i++){
          audioValues[i] = audioData[i];
          Log.e(LOG_TAG, "bit"  + audioValues[i] );
        }
        reads++;
        Log.e(LOG_TAG, "marker reached " + reads );

        events.success(audioValues);
      }
    };
  }
}

