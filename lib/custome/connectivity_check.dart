import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

enum ConnectivityStatus { initial, connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  Timer? _periodicCheckTimer;

  ConnectivityCubit() : super(ConnectivityStatus.initial) {
    developer.log('ConnectivityCubit initialized', name: 'ConnectivityCubit');
    _init();
    _startPeriodicCheck();
  }

  Future<void> _init() async {
    developer.log('Initializing connectivity check', name: 'ConnectivityCubit');

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        developer.log('No network connection', name: 'ConnectivityCubit');
        emit(ConnectivityStatus.disconnected);
      } else {
        // Check if there is actual internet access
        final hasInternet = await _checkInternetAccess();
        if (hasInternet) {
          developer.log('Internet connected', name: 'ConnectivityCubit');
          emit(ConnectivityStatus.connected);
        } else {
          developer.log('No internet access (e.g., data exhausted)', name: 'ConnectivityCubit');
          emit(ConnectivityStatus.disconnected);
        }
      }
    });

    // Check the initial connectivity status
    final initialResult = await _connectivity.checkConnectivity();
    if (initialResult == ConnectivityResult.none) {
      developer.log('Initial state: No network connection', name: 'ConnectivityCubit');
      emit(ConnectivityStatus.disconnected);
    } else {
      final hasInternet = await _checkInternetAccess();
      if (hasInternet) {
        developer.log('Initial state: Internet connected', name: 'ConnectivityCubit');
        emit(ConnectivityStatus.connected);
      } else {
        developer.log('Initial state: No internet access', name: 'ConnectivityCubit');
        emit(ConnectivityStatus.disconnected);
      }
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      // Make a request to a reliable server (e.g., Google) with a timeout of 5 seconds
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5)); // Set a timeout of 5 seconds

      return response.statusCode == 200; // If the request is successful, there is internet access
    } on TimeoutException {
      developer.log('Internet check timed out', name: 'ConnectivityCubit');
      return false; // No internet access if the request times out
    } catch (e) {
      developer.log('Error checking internet access: $e', name: 'ConnectivityCubit');
      return false; // No internet access if there's an error
    }
  }

  void _startPeriodicCheck() {
    // Check internet access every 10 seconds
    _periodicCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      developer.log('Running periodic internet check', name: 'ConnectivityCubit');
      final hasInternet = await _checkInternetAccess();
      developer.log("hasInternet: ${hasInternet}", name: 'ConnectivityCubit');
      if (hasInternet) {
        emit(ConnectivityStatus.connected);
      } else {
        emit(ConnectivityStatus.disconnected);
      }
    });
  }

  @override
  Future<void> close() {
    developer.log('ConnectivityCubit closed', name: 'ConnectivityCubit');
    _connectivitySubscription?.cancel();
    _periodicCheckTimer?.cancel();
    return super.close();
  }
}