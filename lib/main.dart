import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zagel/controller/firebase_options.dart';
import 'package:zagel/screens/options.dart';
import 'package:zagel/screens/splash_screen/splash.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests notification permission and handles different permission statuses.
Future<void> _requestBluetoothScanPermission() async {
  final PermissionStatus status = await Permission.bluetoothScan.request();
  if (status.isGranted) {
    // Permission granted, you can now show notifications
  } else if (status.isDenied) {
    // Permission denied
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings
    openAppSettings();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _requestBluetoothScanPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // Set the initial route based on connectivity
      initialRoute: '/splash',
      // Define routes for different screens
      routes: {
        '/splash': (context) => SplashScreen(),
        '/options': (context) => OptionsScreen(),
      },
    );
  }
}
