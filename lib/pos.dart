
import 'pos_platform_interface.dart';

class Pos {
  Future<String?> getPlatformVersion() {
    return PosPlatform.instance.getPlatformVersion();
  }

  Future<bool?> beepDevice(){
    return PosPlatform.instance.beepDevice();
  }

  Future<bool?> toggleLed(){
    return PosPlatform.instance.toggleLed();
  }

  Future<String?> initDeviceEngine(){
    return PosPlatform.instance.initDeviceEngine();
  }
}
