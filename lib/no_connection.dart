import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:open_settings_plus/android/open_settings_plus_android.dart';
import 'package:open_settings_plus/ios/open_settings_plus_ios.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LottieBuilder.asset(
            'assets/no-connection.json',
            height: 220,
          ),
          const SizedBox(
            height: 15,
          ),
          const Center(
            child: Text(
              'No internet connection.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          // Got to settings button
          const SizedBox(
            height: 15,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => _launchInternetSettings(),
              child: const Text('Go to Wifi settings'),
            ),
          ),
        ],
      ),
    );
  }

  Future _launchInternetSettings() async {
    if (Platform.isAndroid) {
      await const OpenSettingsPlusAndroid().wifi();
      return;
    }
    await const OpenSettingsPlusIOS().wifi();
  }
}
