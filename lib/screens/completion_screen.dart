import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/providers/flash_provider.dart';
import 'package:smith/screens/welcome_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatrixTheme.matrixBlack,
      body: Stack(
        children: [
          const DigitalRainAnimation(),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: MatrixTheme.matrixGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: MatrixTheme.matrixGreen,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MatrixTheme.matrixGreen.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: MatrixTheme.matrixGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'FLASHING COMPLETE!',
                        style: MatrixTheme.matrixHeading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Consumer<DeviceProvider>(
                        builder: (context, deviceProvider, child) {
                          if (deviceProvider.currentDevice == null) {
                            return const Text(
                              'Your device has been successfully flashed with SlateOS!',
                              style: MatrixTheme.matrixText,
                              textAlign: TextAlign.center,
                            );
                          }
                          
                          return Column(
                            children: [
                              Text(
                                '${deviceProvider.currentDevice!.name} has been successfully flashed with SlateOS!',
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
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: MatrixTheme.matrixCardDecoration,
                        child: const Column(
                          children: [
                            Text(
                              'What\'s Next?',
                              style: MatrixTheme.matrixSubheading,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '• Your device will boot into SlateOS\n'
                              '• Complete the initial setup process\n'
                              '• Configure your privacy settings\n'
                              '• Install your preferred apps\n'
                              '• Enjoy enhanced privacy and security!',
                              style: MatrixTheme.matrixText,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
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
                              'Important Notes',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Keep your device connected until it fully boots\n'
                              '• First boot may take 5-10 minutes\n'
                              '• You may need to re-enable USB debugging\n'
                              '• Some apps may need to be reinstalled',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      MatrixButton(
                        text: 'FINISH',
                        onPressed: () {
                          // Reset providers and go back to welcome screen
                          context.read<DeviceProvider>().disconnectDevice();
                          context.read<FlashProvider>().reset();
                          
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
