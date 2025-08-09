import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smith/models/device_model.dart';
import 'package:smith/utils/logger.dart';

class DeviceService {
  List<UsbDevice>? _devices;
  UsbPort? _port;
  StreamSubscription? _subscription;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      // Request USB permissions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('USB permission not granted');
      }

      _isInitialized = true;
      Logger.i('DeviceService initialized');
    } catch (e) {
      Logger.e('Failed to initialize DeviceService: $e');
      rethrow;
    }
  }

  Future<List<DeviceModel>> scanForDevices() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      _devices = await UsbSerial.listDevices();
      final List<DeviceModel> detectedDevices = [];

      for (final device in _devices!) {
        final deviceModel = _createDeviceModel(device);
        if (deviceModel != null) {
          detectedDevices.add(deviceModel);
        }
      }

      Logger.i('Found ${detectedDevices.length} devices');
      return detectedDevices;
    } catch (e) {
      Logger.e('Failed to scan for devices: $e');
      return [];
    }
  }

  DeviceModel? _createDeviceModel(UsbDevice device) {
    try {
      // This is a simplified implementation
      // In a real app, you'd need to query the device for more details
      final productName = device.productName ?? 'Unknown Device';
      final manufacturerName = device.manufacturerName ?? 'Unknown';
      
      // Check if it's a Pixel device by looking for Google in manufacturer
      if (manufacturerName.toLowerCase().contains('google') ||
          productName.toLowerCase().contains('pixel')) {
        
        // Try to determine the specific model
        String codename = 'unknown';
        String model = 'Unknown';
        String name = productName;
        
        // This would need to be enhanced with actual device detection logic
        if (productName.toLowerCase().contains('pixel 7a')) {
          codename = 'akita';
          model = 'G0DZQ';
          name = 'Pixel 7a';
        } else if (productName.toLowerCase().contains('pixel 8')) {
          codename = 'shiba';
          model = 'G9BQD';
          name = 'Pixel 8';
        } else if (productName.toLowerCase().contains('pixel 8a')) {
          codename = 'husky';
          model = 'G6QUJ';
          name = 'Pixel 8a';
        } else if (productName.toLowerCase().contains('pixel 8 pro')) {
          codename = 'komodo';
          model = 'GC3VE';
          name = 'Pixel 8 Pro';
        } else if (productName.toLowerCase().contains('pixel 9a')) {
          codename = 'lynx';
          model = 'G1AZG';
          name = 'Pixel 9a';
        }

        return DeviceModel(
          id: device.deviceId.toString(),
          name: name,
          model: model,
          codename: codename,
          isSupported: SupportedDevices.isDeviceSupported(codename),
          serialNumber: null, // UsbDevice doesn't have serialNumber property
        );
      }
      
      return null;
    } catch (e) {
      Logger.e('Failed to create device model: $e');
      return null;
    }
  }

  Future<bool> checkBootloaderStatus() async {
    try {
      if (_port == null) {
        throw Exception('No device connected');
      }

      // Send fastboot command to check bootloader status
      final response = await _sendFastbootCommand('getvar unlocked');
      return response.toLowerCase().contains('yes');
    } catch (e) {
      Logger.e('Failed to check bootloader status: $e');
      return false;
    }
  }

  Future<bool> unlockBootloader() async {
    try {
      if (_port == null) {
        throw Exception('No device connected');
      }

      // Send fastboot unlock command
      final response = await _sendFastbootCommand('flashing unlock');
      return response.toLowerCase().contains('okay');
    } catch (e) {
      Logger.e('Failed to unlock bootloader: $e');
      return false;
    }
  }

  Future<int> checkBatteryLevel() async {
    try {
      if (_port == null) {
        throw Exception('No device connected');
      }

      // This would need to be implemented based on the specific device protocol
      // For now, return a default value
      return 100;
    } catch (e) {
      Logger.e('Failed to check battery level: $e');
      return 0;
    }
  }

  Future<String> _sendFastbootCommand(String command) async {
    try {
      if (_port == null) {
        throw Exception('No device connected');
      }

      // Send command - simplified implementation
      final commandBytes = command.codeUnits;
      await _port!.write(Uint8List.fromList(commandBytes));
      
      // Wait for response - simplified implementation
      // In a real implementation, you'd need to properly handle the response
      await Future.delayed(const Duration(seconds: 1));
      return 'okay'; // Placeholder response
    } catch (e) {
      Logger.e('Failed to send fastboot command: $e');
      rethrow;
    }
  }

  Future<bool> connectToDevice(DeviceModel device) async {
    try {
      if (_devices == null) {
        await scanForDevices();
      }

      final usbDevice = _devices!.firstWhere(
        (d) => d.deviceId.toString() == device.id,
        orElse: () => throw Exception('Device not found'),
      );

      _port = await usbDevice.create();
      if (_port == null) {
        throw Exception('Failed to connect to device');
      }

      // Set up data listener - simplified implementation
      // In a real implementation, you'd need to properly handle the input stream
      Logger.i('Connected to device: ${device.name}');
      return true;
    } catch (e) {
      Logger.e('Failed to connect to device: $e');
      return false;
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _port?.close();
    _port = null;
    Logger.i('Disconnected from device');
  }

  void dispose() {
    disconnect();
  }
}
