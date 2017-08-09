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
    mInBufferSize = AudioRecord.getMinBufferSize(
            mSampleRate, AudioFormat.CHANNEL_IN_MONO, mFormat
    )*2;
    //https://stackoverflow.com/questions/15804903/android-dev-audiorecord-without-blocking-or-threads
    //require android 5
    //2bytes in a short. So number of frames is totalbytes/2
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
        int shortOut = recorder.read(audioData,0,mPeriodFrames);
        //https://flutter.io/platform-channels/#codec
        //convert short to byte because platformchannel limitation
        byte[] audioValues = new byte[audioData.length*2];
        //Log.e(LOG_TAG, "shorts read: " + shortOut + " periodframes : " + mPeriodFrames + "frames: " + mRecorder.getBufferSizeInFrames() );
        //make a copy of values to pass
        for(int i = 0; i< shortOut; i++){
          audioValues[i*2] = (byte)(audioData[i]& 0xff);
          audioValues[i*2+1] = (byte)((audioData[i]>> 8) & 0xff);
        }
        reads++;
        //Log.e(LOG_TAG, "marker reached " + reads );

        events.success(audioValues);
      }
    };
  }
}

