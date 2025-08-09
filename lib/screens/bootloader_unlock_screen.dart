import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/screens/rom_download_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class BootloaderUnlockScreen extends StatefulWidget {
  const BootloaderUnlockScreen({super.key});

  @override
  State<BootloaderUnlockScreen> createState() => _BootloaderUnlockScreenState();
}

class _BootloaderUnlockScreenState extends State<BootloaderUnlockScreen> {
  bool _isUnlocking = false;
  bool _isUnlocked = false;
  String _status = 'Ready to unlock bootloader';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      appBar: AppBar(
        title: const Text('Unlock Bootloader'),
        backgroundColor: MatrixTheme.matrixBlack,
        foregroundColor: MatrixTheme.matrixGreen,
      ),
      body: Stack(
        children: [
          const DigitalRainAnimation(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: MatrixTheme.matrixCardDecoration,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.lock_open,
                          size: 48,
                          color: MatrixTheme.matrixGreen,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Unlock Bootloader',
                          style: MatrixTheme.matrixSubheading,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'This step will unlock the bootloader on your Pixel device. '
                          'This process will erase all data on your device.',
                          style: MatrixTheme.matrixText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '⚠️  WARNING: Data Loss',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Unlocking the bootloader will completely erase all data on your device, including:\n'
                          '• All apps and app data\n'
                          '• Photos, videos, and music\n'
                          '• Contacts and messages\n'
                          '• Settings and preferences\n\n'
                          'Make sure you have backed up all important data before proceeding.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MatrixTheme.matrixDarkGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MatrixTheme.matrixGreen),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Status',
                          style: MatrixTheme.matrixSubheading,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _status,
                          style: MatrixTheme.matrixText,
                          textAlign: TextAlign.center,
                        ),
                        if (_isUnlocking) ...[
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MatrixTheme.matrixGreen,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!_isUnlocked) ...[
                    MatrixButton(
                      text: _isUnlocking ? 'UNLOCKING...' : 'UNLOCK BOOTLOADER',
                      onPressed: _isUnlocking ? null : _unlockBootloader,
                      isLoading: _isUnlocking,
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MatrixTheme.matrixGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: MatrixTheme.matrixGreen),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: MatrixTheme.matrixGreen,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bootloader unlocked successfully!',
                              style: MatrixTheme.matrixText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    MatrixButton(
                      text: 'NEXT: DOWNLOAD ROM',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RomDownloadScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _unlockBootloader() async {
    setState(() {
      _isUnlocking = true;
      _status = 'Checking device connection...';
    });

    try {
      final deviceProvider = context.read<DeviceProvider>();
      
      // Check if device is connected
      if (deviceProvider.currentDevice == null) {
        throw Exception('No device connected');
      }

      setState(() {
        _status = 'Checking bootloader status...';
      });

      // Check current bootloader status
      final isUnlocked = await deviceProvider.checkBootloaderStatus();
      
      if (isUnlocked) {
        setState(() {
          _isUnlocked = true;
          _status = 'Bootloader is already unlocked';
          _isUnlocking = false;
        });
        return;
      }

      setState(() {
        _status = 'Unlocking bootloader...';
      });

      // Attempt to unlock bootloader
      final success = await deviceProvider.unlockBootloader();
      
      if (success) {
        setState(() {
          _isUnlocked = true;
          _status = 'Bootloader unlocked successfully!';
          _isUnlocking = false;
        });
      } else {
        throw Exception('Failed to unlock bootloader');
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isUnlocking = false;
      });
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: MatrixTheme.matrixDarkGray,
            title: const Text(
              'Unlock Failed',
              style: MatrixTheme.matrixText,
            ),
            content: Text(
              'Failed to unlock bootloader: $e\n\n'
              'Please make sure:\n'
              '• Device is connected via USB\n'
              '• Developer options are enabled\n'
              '• OEM unlocking is enabled\n'
              '• USB debugging is enabled',
              style: MatrixTheme.matrixText,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: MatrixTheme.matrixText,
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
