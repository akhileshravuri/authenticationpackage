# Flutter Biometric Authentication Package

A Flutter package that provides biometric authentication, face unlock, and PIN verification functionality.

## Features

- Biometric authentication (fingerprint, face ID)
- Face unlock
- PIN verification
- Secure storage for PIN
- Cross-platform support (iOS and Android)

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  biometric_auth: ^0.0.1
```

## Usage

```dart
import 'package:biometric_auth/biometric_auth.dart';

final biometricService = BiometricService();

// Check if biometric authentication is available
bool isAvailable = await biometricService.isBiometricAvailable();

// Authenticate with biometrics
bool isAuthenticated = await biometricService.authenticateWithBiometrics();

// Authenticate with face
bool isFaceAuthenticated = await biometricService.authenticateWithFace();

// Set PIN
await biometricService.setPin('123456');

// Verify PIN
bool isPinValid = await biometricService.verifyPin('123456');

// Clear PIN
await biometricService.clearPin();

// Get available biometrics
List<BiometricType> availableBiometrics = await biometricService.getAvailableBiometrics();
```

## Platform Integration

### iOS

Add the following to your `Info.plist`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>We need your permission to use Face ID for authentication.</string>
<key>NSCameraUsageDescription</key>
<string>We need your permission to use the camera for face detection.</string>
```

### Android

Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

## Security

- PINs are stored securely using `flutter_secure_storage`
- Biometric authentication is handled through platform-specific secure APIs
- All sensitive operations are performed using platform-provided secure enclaves
