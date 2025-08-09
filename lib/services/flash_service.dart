import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smith/models/device_model.dart';
import 'package:smith/utils/logger.dart';

class FlashService {
  final Dio _dio = Dio();
  bool _isDisposed = false;

  FlashService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 300);
  }

  // Download ROM from server
  Future<String> downloadRom(
    String romUrl,
    String codename,
    Function(double) onProgress,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final romDir = Directory('${directory.path}/roms');
      if (!await romDir.exists()) {
        await romDir.create(recursive: true);
      }

      final fileName = '${codename}-factory.zip';
      final filePath = '${romDir.path}/$fileName';
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        Logger.i('ROM already exists at $filePath');
        return filePath;
      }

      Logger.i('Downloading ROM from $romUrl');
      
      await _dio.download(
        romUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      Logger.i('ROM downloaded successfully to $filePath');
      return filePath;
    } catch (e) {
      Logger.e('Failed to download ROM: $e');
      rethrow;
    }
  }

  // Flash ROM to device
  Future<bool> flashRom(
    String romPath,
    DeviceModel device,
    Function(double, String) onProgress,
  ) async {
    try {
      Logger.i('Starting ROM flash for ${device.name}');
      
      // This is a simplified implementation
      // In a real app, you'd need to implement the actual fastboot flashing logic
      
      // Simulate flashing process
      final steps = [
        'Preparing device...',
        'Erasing partitions...',
        'Flashing system partition...',
        'Flashing vendor partition...',
        'Flashing boot partition...',
        'Flashing recovery partition...',
        'Finalizing...',
      ];

      for (int i = 0; i < steps.length; i++) {
        if (_isDisposed) break;
        
        final progress = (i + 1) / steps.length;
        onProgress(progress, steps[i]);
        
        // Simulate step duration
        await Future.delayed(const Duration(seconds: 2));
      }

      Logger.i('ROM flash completed successfully');
      return true;
    } catch (e) {
      Logger.e('Failed to flash ROM: $e');
      return false;
    }
  }

  // Check if ROM is downloaded
  Future<bool> isRomDownloaded(String codename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final romDir = Directory('${directory.path}/roms');
      final fileName = '${codename}-factory.zip';
      final filePath = '${romDir.path}/$fileName';
      final file = File(filePath);
      
      return await file.exists();
    } catch (e) {
      Logger.e('Failed to check ROM download status: $e');
      return false;
    }
  }

  // Get ROM file path
  Future<String?> getRomPath(String codename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final romDir = Directory('${directory.path}/roms');
      final fileName = '${codename}-factory.zip';
      final filePath = '${romDir.path}/$fileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        return filePath;
      }
      return null;
    } catch (e) {
      Logger.e('Failed to get ROM path: $e');
      return null;
    }
  }

  // Delete downloaded ROM
  Future<bool> deleteRom(String codename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final romDir = Directory('${directory.path}/roms');
      final fileName = '${codename}-factory.zip';
      final filePath = '${romDir.path}/$fileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        Logger.i('ROM deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      Logger.e('Failed to delete ROM: $e');
      return false;
    }
  }

  void dispose() {
    _isDisposed = true;
    _dio.close();
  }
}
