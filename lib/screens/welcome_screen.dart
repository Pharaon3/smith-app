import 'package:flutter/material.dart';
import 'package:smith/screens/device_connection_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
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
          // Digital rain background
          const DigitalRainAnimation(),
          
          // Content
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Title
                      const Icon(
                        Icons.phone_android,
                        size: 80,
                        color: MatrixTheme.matrixGreen,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'SMITH FLASHER',
                        style: MatrixTheme.matrixHeading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Untrackable. Unbreakable. Your privacy, fortified.',
                        style: MatrixTheme.matrixSubheading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '(Forged from GrapheneOS)',
                        style: TextStyle(
                          color: MatrixTheme.matrixLightGray,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      
                      // Description
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: MatrixTheme.matrixCardDecoration,
                        child: const Column(
                          children: [
                            Text(
                              'Welcome to Smith: Flash Your Pixel',
                              style: MatrixTheme.matrixSubheading,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'This app will guide you through the process of flashing SlateOS to your Pixel device. '
                              'The process is designed to be simple and safe, even for users with limited technical experience.',
                              style: MatrixTheme.matrixText,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '⚠️  WARNING: Flashing will erase all data on your device. Please backup your data before proceeding.',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Start button
                      MatrixButton(
                        text: 'START FLASHING',
                        onPressed: () {
                          print("hello");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DeviceConnectionScreen(),
                            ),
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
