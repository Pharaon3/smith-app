import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/providers/flash_provider.dart';
import 'package:smith/screens/flashing_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class RomDownloadScreen extends StatefulWidget {
  const RomDownloadScreen({super.key});

  @override
  State<RomDownloadScreen> createState() => _RomDownloadScreenState();
}

class _RomDownloadScreenState extends State<RomDownloadScreen> {
  bool _isDownloading = false;
  bool _isDownloaded = false;
  double _progress = 0.0;
  String _status = 'Ready to download ROM';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingRom();
    });
  }

  Future<void> _checkExistingRom() async {
    final deviceProvider = context.read<DeviceProvider>();
    final flashProvider = context.read<FlashProvider>();
    
    if (deviceProvider.currentDevice != null) {
      flashProvider.setTargetDevice(deviceProvider.currentDevice!);
      
      // Check if ROM is already downloaded
      final isDownloaded = await flashProvider.isRomDownloaded();
      
      if (isDownloaded) {
        setState(() {
          _isDownloaded = true;
          _status = 'ROM already downloaded';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      appBar: AppBar(
        title: const Text('Download ROM'),
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
                          Icons.download,
                          size: 48,
                          color: MatrixTheme.matrixGreen,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Download ROM',
                          style: MatrixTheme.matrixSubheading,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Consumer<DeviceProvider>(
                          builder: (context, deviceProvider, child) {
                            if (deviceProvider.currentDevice == null) {
                              return const Text(
                                'No device detected',
                                style: MatrixTheme.matrixText,
                                textAlign: TextAlign.center,
                              );
                            }
                            
                            return Column(
                              children: [
                                Text(
                                  'Device: ${deviceProvider.currentDevice!.name}',
                                  style: MatrixTheme.matrixText,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Codename: ${deviceProvider.currentDevice!.codename}',
                                  style: MatrixTheme.matrixText,
                                  textAlign: TextAlign.center,
                                ),
                                if (deviceProvider.currentDevice!.romVersion != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'ROM Version: ${deviceProvider.currentDevice!.romVersion}',
                                    style: MatrixTheme.matrixText,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            );
                          },
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
                          'Download Status',
                          style: MatrixTheme.matrixSubheading,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _status,
                          style: MatrixTheme.matrixText,
                          textAlign: TextAlign.center,
                        ),
                        if (_isDownloading || _isDownloaded) ...[
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: _isDownloaded ? 1.0 : _progress,
                            backgroundColor: MatrixTheme.matrixDarkGray,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              MatrixTheme.matrixGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isDownloaded 
                                ? '100% Complete'
                                : '${(_progress * 100).toInt()}%',
                            style: MatrixTheme.matrixText,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ROM Information',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• ROM size: ~2-3 GB\n'
                          '• Download time: 5-15 minutes (depending on connection)\n'
                          '• ROM will be stored locally on your device\n'
                          '• You can reuse the downloaded ROM for future flashes',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!_isDownloaded) ...[
                    MatrixButton(
                      text: _isDownloading ? 'DOWNLOADING...' : 'DOWNLOAD ROM',
                      onPressed: _isDownloading ? null : _downloadRom,
                      isLoading: _isDownloading,
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
                              'ROM downloaded successfully!',
                              style: MatrixTheme.matrixText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    MatrixButton(
                      text: 'NEXT: FLASH ROM',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FlashingScreen(),
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

  Future<void> _downloadRom() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _status = 'Starting download...';
    });

    try {
      final deviceProvider = context.read<DeviceProvider>();
      final flashProvider = context.read<FlashProvider>();
      
      if (deviceProvider.currentDevice == null) {
        throw Exception('No device connected');
      }

      if (deviceProvider.currentDevice!.romUrl == null) {
        throw Exception('No ROM URL available for this device');
      }

      setState(() {
        _status = 'Downloading ROM...';
      });

      final success = await flashProvider.downloadRom();
      
      if (success) {
        setState(() {
          _isDownloaded = true;
          _isDownloading = false;
          _progress = 1.0;
          _status = 'ROM downloaded successfully!';
        });
      } else {
        throw Exception('Download failed');
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isDownloading = false;
      });
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: MatrixTheme.matrixDarkGray,
            title: const Text(
              'Download Failed',
              style: MatrixTheme.matrixText,
            ),
            content: Text(
              'Failed to download ROM: $e\n\n'
              'Please check your internet connection and try again.',
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
