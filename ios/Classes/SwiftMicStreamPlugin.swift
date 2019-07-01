import Flutter
import UIKit
import AVFoundation
/*
 * https://developer.apple.com/documentation/avfoundation/avaudioengine
 *  Flutter Stream https://api.flutter.dev/objcdoc/Protocols/FlutterStreamHandler.html
 * https://github.com/flutter/flutter/blob/master/examples/platform_channel_swift/ios/Runner/AppDelegate.swift
 * https://stackoverflow.com/questions/39909243/implementing-callback-for-auaudiobuffer-in-avaudioengine
 * https://stackoverflow.com/questions/49370169/ios-swift-record-audio-with-16khz-on-every-hardware-using-avaudioengine
 * https://developer.apple.com/documentation/avfoundation/avaudionode
 * https://developer.apple.com/documentation/avfoundation/avaudionode/1387122-installtap
 * https://stackoverflow.com/questions/41804790/how-to-use-avaudionodetapblock-in-a-tap-in-avaudioengine
 */

@available(iOS 9.0, *)
public class SwiftMicStreamPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  let engine = AVAudioEngine()

  private var outputFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: false)
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mic_stream", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "com.yourcompany.micstream/record", binaryMessenger: registrar.messenger())
    let instance = SwiftMicStreamPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    let inNode = engine.inputNode
    let inFormat = inNode.outputFormat(forBus: 0)
    let converter = AVAudioConverter(from: inFormat, to: outputFormat)
    let mixer = AVAudioMixerNode()

    engine.attach(mixer)
    engine.connect(inNode, to: mixer, format: inFormat)

    mixer.installTap(onBus: 0, bufferSize: 8192, format: outputFormat, block: {buffer, when in
      var byteBuffer = Array<UInt8>(repeating: 0, count: buffer.frameLength * 2)
      for idx in 1...buffer.frameLength {
        byteBuffer[idx*2] =  buffer[idx] & 0xFF
        byteBuffer[idx*2+1] = (buffer[idx] >> 8) & 0xFF
      }
      events(byteBuffer)
    }) 
    try! engine.start()
    return nil
  }
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    engine.stop()
    return nil
  }
}
