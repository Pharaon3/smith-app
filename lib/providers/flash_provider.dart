import 'package:flutter/foundation.dart';
import 'package:smith/models/device_model.dart';
import 'package:smith/services/flash_service.dart';
import 'package:smith/utils/logger.dart';

enum FlashState {
  idle,
  downloading,
  flashing,
  completed,
  error,
}

class FlashProvider extends ChangeNotifier {
  FlashState _state = FlashState.idle;
  double _progress = 0.0;
  String _status = 'Ready';
  String? _error;
  DeviceModel? _targetDevice;
  String? _romPath;

  FlashState get state => _state;
  double get progress => _progress;
  String get status => _status;
  String? get error => _error;
  DeviceModel? get targetDevice => _targetDevice;
  String? get romPath => _romPath;

  final FlashService _flashService = FlashService();

  // Set target device
  void setTargetDevice(DeviceModel device) {
    _targetDevice = device;
    notifyListeners();
  }

  // Download ROM
  Future<bool> downloadRom() async {
    try {
      if (_targetDevice == null) {
        throw Exception('No target device selected');
      }

      if (_targetDevice!.romUrl == null) {
        throw Exception('No ROM URL available for this device');
      }

      _setState(FlashState.downloading);
      _setProgress(0.0);
      _setStatus('Starting ROM download...');

      _romPath = await _flashService.downloadRom(
        _targetDevice!.romUrl!,
        _targetDevice!.codename,
        (progress) {
          _setProgress(progress);
          _setStatus('Downloading ROM... ${(progress * 100).toInt()}%');
        },
      );

      _setStatus('ROM downloaded successfully');
      return true;
    } catch (e) {
      _setError('Failed to download ROM: $e');
      Logger.e('FlashProvider.downloadRom: $e');
      return false;
    }
  }

  // Flash ROM to device
  Future<bool> flashRom() async {
    try {
      if (_targetDevice == null) {
        throw Exception('No target device selected');
      }

      if (_romPath == null) {
        throw Exception('No ROM downloaded');
      }

      _setState(FlashState.flashing);
      _setProgress(0.0);
      _setStatus('Starting ROM flash...');

      final success = await _flashService.flashRom(
        _romPath!,
        _targetDevice!,
        (progress, status) {
          _setProgress(progress);
          _setStatus(status);
        },
      );

      if (success) {
        _setState(FlashState.completed);
        _setStatus('ROM flashed successfully');
        Logger.i('ROM flashed successfully to ${_targetDevice!.name}');
      } else {
        throw Exception('Flashing failed');
      }

      return success;
    } catch (e) {
      _setError('Failed to flash ROM: $e');
      Logger.e('FlashProvider.flashRom: $e');
      return false;
    }
  }

  // Check if device is ready for flashing
  bool isDeviceReady() {
    if (_targetDevice == null) return false;
    if (!_targetDevice!.isConnected) return false;
    if (!_targetDevice!.isUnlocked) return false;
    if (_targetDevice!.batteryLevel < 50) return false;
    return true;
  }

  // Check if ROM is downloaded for the target device
  Future<bool> isRomDownloaded() async {
    if (_targetDevice == null) return false;
    return await _flashService.isRomDownloaded(_targetDevice!.codename);
  }

  // Get ROM path for the target device
  Future<String?> getRomPath() async {
    if (_targetDevice == null) return null;
    return await _flashService.getRomPath(_targetDevice!.codename);
  }

  // Reset state
  void reset() {
    _state = FlashState.idle;
    _progress = 0.0;
    _status = 'Ready';
    _error = null;
    _romPath = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private methods
  void _setState(FlashState state) {
    _state = state;
    notifyListeners();
  }

  void _setProgress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void _setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _state = FlashState.error;
    notifyListeners();
  }

  @override
  void dispose() {
    _flashService.dispose();
    super.dispose();
  }
}
