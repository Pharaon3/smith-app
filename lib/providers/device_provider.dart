import 'package:flutter/foundation.dart';
import 'package:smith/models/device_model.dart';
import 'package:smith/services/device_service.dart';
import 'package:smith/utils/logger.dart';

class DeviceProvider extends ChangeNotifier {
  DeviceModel? _currentDevice;
  bool _isScanning = false;
  bool _isConnected = false;
  String _status = 'Ready';
  String? _error;

  DeviceModel? get currentDevice => _currentDevice;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  String get status => _status;
  String? get error => _error;

  final DeviceService _deviceService = DeviceService();

  // Initialize device detection
  Future<void> initialize() async {
    try {
      _setStatus('Initializing device detection...');
      await _deviceService.initialize();
      _setStatus('Ready to detect devices');
    } catch (e) {
      _setError('Failed to initialize: $e');
      Logger.e('DeviceProvider.initialize: $e');
    }
  }

  // Scan for connected devices
  Future<void> scanForDevices() async {
    try {
      _setScanning(true);
      _setStatus('Scanning for devices...');
      
      final devices = await _deviceService.scanForDevices();
      
      if (devices.isNotEmpty) {
        final device = devices.first;
        _currentDevice = device;
        _isConnected = true;
        _setStatus('${device.name} detected');
        Logger.i('Device detected: ${device.name} (${device.codename})');
      } else {
        _setStatus('No devices found. Please connect a Pixel device.');
      }
    } catch (e) {
      _setError('Failed to scan for devices: $e');
      Logger.e('DeviceProvider.scanForDevices: $e');
    } finally {
      _setScanning(false);
    }
  }

  // Check if device is supported
  bool isDeviceSupported() {
    if (_currentDevice == null) return false;
    return SupportedDevices.isDeviceSupported(_currentDevice!.codename);
  }

  // Check bootloader status
  Future<bool> checkBootloaderStatus() async {
    try {
      if (_currentDevice == null) return false;
      
      _setStatus('Checking bootloader status...');
      final isUnlocked = await _deviceService.checkBootloaderStatus();
      
      _currentDevice = _currentDevice!.copyWith(isUnlocked: isUnlocked);
      _setStatus(isUnlocked ? 'Bootloader is unlocked' : 'Bootloader is locked');
      
      return isUnlocked;
    } catch (e) {
      _setError('Failed to check bootloader status: $e');
      Logger.e('DeviceProvider.checkBootloaderStatus: $e');
      return false;
    }
  }

  // Unlock bootloader
  Future<bool> unlockBootloader() async {
    try {
      if (_currentDevice == null) return false;
      
      _setStatus('Unlocking bootloader...');
      final success = await _deviceService.unlockBootloader();
      
      if (success) {
        _currentDevice = _currentDevice!.copyWith(isUnlocked: true);
        _setStatus('Bootloader unlocked successfully');
        Logger.i('Bootloader unlocked for ${_currentDevice!.name}');
      } else {
        _setError('Failed to unlock bootloader');
      }
      
      return success;
    } catch (e) {
      _setError('Failed to unlock bootloader: $e');
      Logger.e('DeviceProvider.unlockBootloader: $e');
      return false;
    }
  }

  // Check battery level
  Future<int> checkBatteryLevel() async {
    try {
      if (_currentDevice == null) return 0;
      
      _setStatus('Checking battery level...');
      final batteryLevel = await _deviceService.checkBatteryLevel();
      
      _currentDevice = _currentDevice!.copyWith(batteryLevel: batteryLevel);
      _setStatus('Battery level: $batteryLevel%');
      
      return batteryLevel;
    } catch (e) {
      _setError('Failed to check battery level: $e');
      Logger.e('DeviceProvider.checkBatteryLevel: $e');
      return 0;
    }
  }

  // Disconnect device
  void disconnectDevice() {
    _currentDevice = null;
    _isConnected = false;
    _setStatus('Device disconnected');
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private methods
  void _setScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }

  void _setStatus(String status) {
    _status = status;
    _error = null;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _status = 'Error';
    notifyListeners();
  }

  @override
  void dispose() {
    _deviceService.dispose();
    super.dispose();
  }
}
