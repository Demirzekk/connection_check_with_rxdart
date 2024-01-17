import 'package:connection_check_with_rxdart/home_page.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'no_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BehaviorSubject<bool> _isConnectedSubject =
      BehaviorSubject<bool>.seeded(true);

  BehaviorSubject<bool> connectionLoosed = BehaviorSubject<bool>.seeded(false);
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnectedSubject.add(result != ConnectivityResult.none);
      if (_isConnectedSubject.value == false) {
        connectionLoosed.add(result == ConnectivityResult.none);
      }
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnectedSubject.add(connectivityResult != ConnectivityResult.none);
    connectionLoosed.add(false);
  }

  @override
  void dispose() {
    _isConnectedSubject.close();
    connectionLoosed.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox(),
        );
      },
      title: 'Flutter İnternet Connection Check Demo',
      home: StreamBuilder(
        stream: Rx.combineLatest2(
            _isConnectedSubject.stream, connectionLoosed.stream, (a, b) {
          return [a, b];
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          bool isInternetConnected = snapshot.data?[0] ?? false;
          bool connectionLoosedBefore = snapshot.data?[1] ?? false;
          if (isInternetConnected == false) {
            _voidShowSnackBar(context, "No internet connection!", Colors.red);
          } else if (isInternetConnected == true &&
              connectionLoosedBefore == true) {
            _voidShowSnackBar(
                context, "Reconnected to the internet!", Colors.green);
          } else {}
          return isInternetConnected == false
              ? const NoConnection()
              : const HomePage();
        },
      ),
    );
  }

  void _voidShowSnackBar(BuildContext context, String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          backgroundColor: color,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ));
    });
  }
}
