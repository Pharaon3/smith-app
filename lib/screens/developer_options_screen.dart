import 'package:flutter/material.dart';
import 'package:smith/screens/bootloader_unlock_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class DeveloperOptionsScreen extends StatefulWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  State<DeveloperOptionsScreen> createState() => _DeveloperOptionsScreenState();
}

class _DeveloperOptionsScreenState extends State<DeveloperOptionsScreen> {
  bool _developerOptionsEnabled = false;
  bool _oemUnlockEnabled = false;
  bool _usbDebuggingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      appBar: AppBar(
        title: const Text('Developer Options'),
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
                          Icons.settings,
                          size: 48,
                          color: MatrixTheme.matrixGreen,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enable Developer Options',
                          style: MatrixTheme.matrixSubheading,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Follow these steps to enable developer options on your Pixel device:',
                          style: MatrixTheme.matrixText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildStepCard(
                            step: 1,
                            title: 'Enable Developer Options',
                            description: 'Go to Settings > About Phone > Tap "Build Number" 7 times',
                            isCompleted: _developerOptionsEnabled,
                            onToggle: (value) {
                              setState(() {
                                _developerOptionsEnabled = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_developerOptionsEnabled) ...[
                            _buildStepCard(
                              step: 2,
                              title: 'Enable OEM Unlock',
                              description: 'Go to Settings > System > Developer Options > Enable "OEM Unlocking"',
                              isCompleted: _oemUnlockEnabled,
                              onToggle: (value) {
                                setState(() {
                                  _oemUnlockEnabled = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildStepCard(
                              step: 3,
                              title: 'Enable USB Debugging',
                              description: 'Go to Settings > System > Developer Options > Enable "USB Debugging"',
                              isCompleted: _usbDebuggingEnabled,
                              onToggle: (value) {
                                setState(() {
                                  _usbDebuggingEnabled = value;
                                });
                              },
                            ),
                          ],
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
                                  'Important Notes:',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Enabling OEM Unlock will allow you to unlock the bootloader\n'
                                  '• Unlocking the bootloader will erase all data on your device\n'
                                  '• Make sure to backup your data before proceeding\n'
                                  '• Keep your device connected via USB throughout the process',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  MatrixButton(
                    text: 'NEXT: UNLOCK BOOTLOADER',
                    onPressed: _allStepsCompleted()
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BootloaderUnlockScreen(),
                              ),
                            );
                          }
                        : null,
                    isDisabled: !_allStepsCompleted(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int step,
    required String title,
    required String description,
    required bool isCompleted,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MatrixTheme.matrixDarkGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? MatrixTheme.matrixGreen : MatrixTheme.matrixLightGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? MatrixTheme.matrixGreen : MatrixTheme.matrixLightGray,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  color: isCompleted ? MatrixTheme.matrixBlack : MatrixTheme.matrixDarkGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isCompleted ? MatrixTheme.matrixGreen : MatrixTheme.matrixLightGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: MatrixTheme.matrixText,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: isCompleted,
            onChanged: onToggle,
            activeColor: MatrixTheme.matrixGreen,
            activeTrackColor: MatrixTheme.matrixGreen.withOpacity(0.3),
            inactiveThumbColor: MatrixTheme.matrixLightGray,
            inactiveTrackColor: MatrixTheme.matrixDarkGray,
          ),
        ],
      ),
    );
  }

  bool _allStepsCompleted() {
    if (!_developerOptionsEnabled) return false;
    if (!_oemUnlockEnabled) return false;
    if (!_usbDebuggingEnabled) return false;
    return true;
  }
}
