import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pos_method_channel.dart';

abstract class PosPlatform extends PlatformInterface {
  /// Constructs a PosPlatform.
  PosPlatform() : super(token: _token);

  static final Object _token = Object();

  static PosPlatform _instance = MethodChannelPos();

  /// The default instance of [PosPlatform] to use.
  ///
  /// Defaults to [MethodChannelPos].
  static PosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PosPlatform] when
  /// they register themselves.
  static set instance(PosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initDeviceEngine() {
    throw UnimplementedError('initDeviceEngine() has not been implemented.');
  }

  Future<bool?> beepDevice() {
    throw UnimplementedError('beepDevice() has not been implemented.');
  }

  Future<bool?> toggleLed() {
    throw UnimplementedError('toggleLed() has not been implemented.');
  }
}

