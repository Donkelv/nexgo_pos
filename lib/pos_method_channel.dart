import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pos_platform_interface.dart';

/// An implementation of [PosPlatform] that uses method channels.
class MethodChannelPos extends PosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pos');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initDeviceEngine() async {
    final initDevice = await methodChannel.invokeMethod('initDevice');
    return initDevice;
  }

  @override
  Future<bool?> beepDevice() async {
    final beepDevice = await methodChannel.invokeMethod('beepDevice');
    return beepDevice;
  }

  @override
  Future<bool?> toggleLed() async {
    final toggleLed = await methodChannel.invokeMethod('toggleLed');
    return toggleLed;
  }
}
