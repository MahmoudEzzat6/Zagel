import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zagel/controller/bleController.dart';
import 'package:zagel/screens/pigeons.dart';

class BleDevicesScreen extends StatefulWidget {
  const BleDevicesScreen({Key? key, required this.enteredId}) : super(key: key);

  final String enteredId;
  @override
  _BleDevicesScreenState createState() => _BleDevicesScreenState();
}

class _BleDevicesScreenState extends State<BleDevicesScreen>
    with SingleTickerProviderStateMixin {
  bool isScanning = false;
  double containerOneSize = 160.0;
  double containerTwoSize = 130.0;
  double containerThreeSize = 100.0;
  double containerPosition = 0.0;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothController bluetoothController = BluetoothController();

  List<BluetoothDevice> availableDevices = [];

  void startScanning() {
    setState(() {
      isScanning = true;
      containerOneSize = 200.0;
      containerTwoSize = 160.0;
      containerThreeSize = 120.0;
      containerPosition = -40.0;
    });

    availableDevices.clear(); // Clear the list before scanning

    flutterBlue.startScan(timeout: Duration(seconds: 60));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        setState(() {
          availableDevices.add(r.device);
        });
      }
    });

    // Stop scanning after 15 seconds
    Future.delayed(Duration(seconds: 60), () {
      flutterBlue.stopScan();
      subscription.cancel();
      setState(() {
        isScanning = false;
        containerOneSize = 160.0;
        containerTwoSize = 130.0;
        containerThreeSize = 100.0;
        containerPosition = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    PigeonFeatures(enteredId: widget.enteredId)));
          },
        ),
        title: Text(
          'Connecting to a device',
          style: GoogleFonts.quicksand(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Scanning animation column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedAlign(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                alignment: Alignment(0, containerPosition / 100),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: containerOneSize,
                  height: containerOneSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      width: containerTwoSize,
                      height: containerTwoSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          width: containerThreeSize,
                          height: containerThreeSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  startScanning();
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4.0,
                                    ),
                                  ),
                                  child: isScanning
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ],
                                        )
                                      : Icon(
                                          Icons.bluetooth,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          // Available devices column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Available Devices',
                  style: GoogleFonts.quicksand(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Divider(
                // Add this line
                color: Colors.grey.withOpacity(0.5),
                thickness: 2.0,
                height: 0.0,
              ),
              if (availableDevices.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'No devices found',
                        style: GoogleFonts.quicksand(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: availableDevices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(availableDevices[index].name),
                      subtitle: Text(availableDevices[index].id.toString()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
