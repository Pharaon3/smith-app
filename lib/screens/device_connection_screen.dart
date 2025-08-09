import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/screens/developer_options_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class DeviceConnectionScreen extends StatefulWidget {
  const DeviceConnectionScreen({super.key});

  @override
  State<DeviceConnectionScreen> createState() => _DeviceConnectionScreenState();
}

class _DeviceConnectionScreenState extends State<DeviceConnectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      appBar: AppBar(
        title: const Text('Device Connection'),
        backgroundColor: MatrixTheme.matrixBlack,
        foregroundColor: MatrixTheme.matrixGreen,
      ),
      body: Stack(
        children: [
          const DigitalRainAnimation(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer<DeviceProvider>(
                builder: (context, deviceProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: MatrixTheme.matrixCardDecoration,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.usb,
                              size: 48,
                              color: MatrixTheme.matrixGreen,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Connect Your Pixel Device',
                              style: MatrixTheme.matrixSubheading,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Connect your Pixel device to this phone using a USB cable. '
                              'Make sure USB debugging is enabled on your device.',
                              style: MatrixTheme.matrixText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Status
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
                              deviceProvider.status,
                              style: MatrixTheme.matrixText,
                              textAlign: TextAlign.center,
                            ),
                            if (deviceProvider.error != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                deviceProvider.error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Device Info
                      if (deviceProvider.currentDevice != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: MatrixTheme.matrixCardDecoration,
                          child: Column(
                            children: [
                              const Text(
                                'Detected Device',
                                style: MatrixTheme.matrixSubheading,
                              ),
                              const SizedBox(height: 16),
                              _buildDeviceInfo(deviceProvider.currentDevice!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Buttons
                      const Spacer(),
                      MatrixButton(
                        text: deviceProvider.isScanning
                            ? 'SCANNING...'
                            : 'SCAN FOR DEVICES',
                        onPressed: deviceProvider.isScanning
                            ? null
                            : () => deviceProvider.scanForDevices(),
                        isLoading: deviceProvider.isScanning,
                      ),
                      const SizedBox(height: 16),
                      if (deviceProvider.currentDevice != null &&
                          deviceProvider.isDeviceSupported()) ...[
                        MatrixButton(
                          text: 'NEXT: ENABLE DEVELOPER OPTIONS',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DeveloperOptionsScreen(),
                              ),
                            );
                          },
                        ),
                      ] else if (deviceProvider.currentDevice != null &&
                          !deviceProvider.isDeviceSupported()) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: const Text(
                            'This device is not supported. Please connect a supported Pixel device.',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfo(device) {
    return Column(
      children: [
        _buildInfoRow('Name', device.name),
        _buildInfoRow('Model', device.model),
        _buildInfoRow('Codename', device.codename),
        _buildInfoRow('Supported', device.isSupported ? 'Yes' : 'No'),
        if (device.serialNumber != null)
          _buildInfoRow('Serial', device.serialNumber!),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: MatrixTheme.matrixText,
          ),
          Text(
            value,
            style: MatrixTheme.matrixText,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
