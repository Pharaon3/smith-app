import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/providers/flash_provider.dart';
import 'package:smith/screens/completion_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class FlashingScreen extends StatefulWidget {
  const FlashingScreen({super.key});

  @override
  State<FlashingScreen> createState() => _FlashingScreenState();
}

class _FlashingScreenState extends State<FlashingScreen> {
  bool _isFlashing = false;
  bool _isCompleted = false;
  double _progress = 0.0;
  String _status = 'Ready to flash ROM';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlashing();
    });
  }

  Future<void> _startFlashing() async {
    setState(() {
      _isFlashing = true;
      _progress = 0.0;
      _status = 'Preparing to flash ROM...';
    });

    try {
      final deviceProvider = context.read<DeviceProvider>();
      final flashProvider = context.read<FlashProvider>();
      
      if (deviceProvider.currentDevice == null) {
        throw Exception('No device connected');
      }

      // Check if device is ready
      if (!flashProvider.isDeviceReady()) {
        throw Exception('Device is not ready for flashing');
      }

      setState(() {
        _status = 'Starting ROM flash...';
      });

      final success = await flashProvider.flashRom();
      
      if (success) {
        setState(() {
          _isCompleted = true;
          _isFlashing = false;
          _progress = 1.0;
          _status = 'ROM flashed successfully!';
        });
      } else {
        throw Exception('Flashing failed');
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isFlashing = false;
      });
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: MatrixTheme.matrixDarkGray,
            title: const Text(
              'Flashing Failed',
              style: MatrixTheme.matrixText,
            ),
            content: Text(
              'Failed to flash ROM: $e\n\n'
              'Please check:\n'
              '• Device is connected via USB\n'
              '• Bootloader is unlocked\n'
              '• Battery level is above 50%\n'
              '• ROM is downloaded successfully',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      appBar: AppBar(
        title: const Text('Flash ROM'),
        backgroundColor: MatrixTheme.matrixBlack,
        foregroundColor: MatrixTheme.matrixGreen,
        automaticallyImplyLeading: false,
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
                          Icons.flash_on,
                          size: 48,
                          color: MatrixTheme.matrixGreen,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Flash ROM',
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
                          'Flashing Status',
                          style: MatrixTheme.matrixSubheading,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _status,
                          style: MatrixTheme.matrixText,
                          textAlign: TextAlign.center,
                        ),
                        if (_isFlashing || _isCompleted) ...[
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: _isCompleted ? 1.0 : _progress,
                            backgroundColor: MatrixTheme.matrixDarkGray,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              MatrixTheme.matrixGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isCompleted 
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
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Important Notes',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Do not disconnect your device during flashing\n'
                          '• The device will reboot multiple times\n'
                          '• Keep the device connected until completion\n'
                          '• Flashing process takes 5-10 minutes',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (_isCompleted) ...[
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
                              'ROM flashed successfully!',
                              style: MatrixTheme.matrixText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    MatrixButton(
                      text: 'NEXT: COMPLETION',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const CompletionScreen(),
                          ),
                        );
                      },
                    ),
                  ] else if (_isFlashing) ...[
                    MatrixButton(
                      text: 'FLASHING IN PROGRESS...',
                      onPressed: null,
                      isDisabled: true,
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
}
