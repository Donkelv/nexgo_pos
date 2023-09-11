import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pos/pos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  dynamic _deviceEngine;
  final _posPlugin = Pos();
  bool? _toggleLed;

  @override
  void initState()  {
    super.initState();
    initPlatformState();
    initDeviceEngine();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _posPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  Future<void> initDeviceEngine() async {
    String initDeviceMessage;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      initDeviceMessage =
          await _posPlugin.initDeviceEngine() ?? 'Unknown platform version';
    } on PlatformException {
      initDeviceMessage = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceEngine = initDeviceMessage;
    });
  }


  Future<bool?> beepDevice() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
        return await _posPlugin.beepDevice() ?? false;
    } on PlatformException catch (err) {
      debugPrint('Failed to beep device. $err');
      return false;
    } catch (err){
      debugPrint( 'Another error for beep device $err');
      return false;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future<bool?> toggleLed() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      return await _posPlugin.toggleLed() ?? false;
    } on PlatformException catch (err) {
      debugPrint('Failed to toggle device. $err');
      return false;
    } catch (err){
      debugPrint( 'Another error for toggle led for device $err');

      return false;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app for Nexgo'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Running on: $_platformVersion\n', ),
            Text('Running on: $_deviceEngine\n', ),
            ElevatedButton(
                onPressed: (){
              beepDevice();
            }, child: Text("Beep Device")
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () async{
                 toggleLed();
                  _toggleLed = await toggleLed();
                }, child: Text("Toggle Led $_toggleLed")
            ),

          ],
        ),
      ),
    );
  }
}
