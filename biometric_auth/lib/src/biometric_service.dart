import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:platform/platform.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _pinKey = 'user_pin';
  final Logger _logger = Logger('BiometricService');
  final Platform _platform = const LocalPlatform();

  Future<bool> isBiometricAvailable() async {
    try {
      _logger.info('Checking biometric availability');
      bool available = await _localAuth.canCheckBiometrics;
      _logger.info('Biometric availability: $available');
      return available;
    } catch (e) {
      _logger.severe('Error checking biometric availability: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      _logger.info('Starting biometric authentication');
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: _getLocalizedReason(),
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      _logger.info('Biometric authentication result: $didAuthenticate');
      return didAuthenticate;
    } catch (e) {
      _logger.severe('Error during biometric authentication: $e');
      return false;
    }
  }

  Future<bool> authenticateWithFace() async {
    try {
      _logger.info('Starting face authentication');
      // Note: Face authentication is not available on all platforms
      if (_platform.isIOS) {
        final bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: _getLocalizedReason(),
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        _logger.info('Face authentication result: $didAuthenticate');
        return didAuthenticate;
      } else {
        _logger.info('Face authentication not supported on this platform');
        return false;
      }
    } catch (e) {
      _logger.severe('Error during face authentication: $e');
      return false;
    }
  }

  Future<bool> setPin(String pin) async {
    try {
      if (pin.length < 4) {
        throw Exception('PIN must be at least 4 characters long');
      }

      _logger.info('Setting PIN');
      await _storage.write(key: _pinKey, value: pin);
      _logger.info('PIN set successfully');
      return true;
    } catch (e) {
      _logger.severe('Error setting PIN: $e');
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      _logger.info('Verifying PIN');
      if (pin.length < 4) {
        return false;
      }

      final String? storedPin = await _storage.read(key: _pinKey);
      bool isValid = storedPin == pin;
      _logger.info('PIN verification result: $isValid');
      return isValid;
    } catch (e) {
      _logger.severe('Error verifying PIN: $e');
      return false;
    }
  }

  Future<String?> getStoredPin() async {
    try {
      _logger.info('Getting stored PIN');
      String? pin = await _storage.read(key: _pinKey);
      _logger.info('PIN retrieved: ${pin != null}');
      return pin;
    } catch (e) {
      _logger.severe('Error getting stored PIN: $e');
      return null;
    }
  }

  Future<bool> clearPin() async {
    try {
      _logger.info('Clearing PIN');
      await _storage.delete(key: _pinKey);
      _logger.info('PIN cleared successfully');
      return true;
    } catch (e) {
      _logger.severe('Error clearing PIN: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      _logger.info('Getting available biometrics');
      List<BiometricType> types = await _localAuth.getAvailableBiometrics();
      _logger.info(
          'Available biometrics: ${types.map((t) => t.toString()).join(', ')}');
      return types;
    } catch (e) {
      _logger.severe('Error getting available biometrics: $e');
      return [];
    }
  }

  String _getLocalizedReason() {
    if (_platform.isIOS) {
      return 'Please authenticate with Face ID/Fingerprint to access the app';
    } else {
      return 'Please authenticate with your fingerprint to access the app';
    }
  }
}

