import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';


class BluetoothController extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;

  // Scan for devices
  void scan({required Function(BluetoothDevice device) onDeviceFound}) {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        onDeviceFound(r.device);
      }
    });

    // Stop scanning after 4 seconds (adjust as needed)
    Future.delayed(Duration(seconds: 4), () {
      flutterBlue.stopScan();
      subscription.cancel();
    });
  }

  // Connect to a device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      targetDevice = device;
      print('Connected to ${device.name}');
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  // Discover services
  Future<void> discoverServices() async {
    if (targetDevice == null) {
      print('Device not connected');
      return;
    }

    List<BluetoothService> services = await targetDevice!.discoverServices();
    services.forEach((service) {
      // You can do something with the service here
      print('Service UUID: ${service.uuid}');
    });
  }

  // Write data to a characteristic
  Future<void> writeToCharacteristic(List<int> data) async {
    if (targetDevice == null || targetCharacteristic == null) {
      print('Device or characteristic not set');
      return;
    }

    try {
      await targetCharacteristic!.write(data);
      print('Data written successfully: $data');
    } catch (e) {
      print('Failed to write data: $e');
    }
  }

  // Set notifications and listen to changes
  Future<void> setNotifications() async {
    if (targetDevice == null || targetCharacteristic == null) {
      print('Device or characteristic not set');
      return;
    }

    try {
      await targetCharacteristic!.setNotifyValue(true);
      targetCharacteristic!.value.listen((value) {
        // Do something with the received value
        print('Received data: $value');
      });
    } catch (e) {
      print('Failed to set notifications: $e');
    }
  }

  // Disconnect from device
  Future<void> disconnect() async {
    if (targetDevice == null) {
      print('Device not connected');
      return;
    }

    try {
      await targetDevice!.disconnect();
      print('Disconnected from ${targetDevice!.name}');
    } catch (e) {
      print('Failed to disconnect: $e');
    }
  }
}