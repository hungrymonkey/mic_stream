import Flutter
import UIKit
import AVFoundation
/*
 * https://developer.apple.com/documentation/avfoundation/avaudioengine
 *  Flutter Stream https://api.flutter.dev/objcdoc/Protocols/FlutterStreamHandler.html
 * https://github.com/flutter/flutter/blob/master/examples/platform_channel_swift/ios/Runner/AppDelegate.swift
 */

public class SwiftMicStreamPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  let engine = AVAudioEngine()

  private var outputFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: false)
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mic_stream", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "com.yourcompany.micstream/record" binaryMessenger: register.messenger())
    let instance = SwiftMicStreamPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    
  }
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    engine.stop()
    return nil
  }
}
