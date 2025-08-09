import 'package:flutter/material.dart';
import 'package:smith/screens/device_connection_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class TargetSettingScreen extends StatefulWidget {
  const TargetSettingScreen({super.key});

  @override
  State<TargetSettingScreen> createState() => _TargetSettingScreenState();
}

class _TargetSettingScreenState extends State<TargetSettingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: MatrixTheme.matrixDarkGray,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: MatrixTheme.matrixGreen),
                          ),
                          child: const Text(
                            'Step 2 of 6',
                            style: MatrixTheme.matrixText,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Main content
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32.0),
                        decoration: MatrixTheme.matrixCardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              'SETTING UP THE TARGET',
                              style: MatrixTheme.matrixHeading,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Supported devices section
                            const Text(
                              'Starting Slate OS ROM Flash',
                              style: TextStyle(
                                color: MatrixTheme.matrixGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Matrix',
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Installation methods
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInstallationMethod(
                                      '1.',
                                      'Set the target device up in OEM unlock mode',
                                    ),
                                    _buildInstallationMethod(
                                      '2.',
                                      'Go to Settings >> Developer Options >> and turn ON the option ‘OEM Unlocking’',
                                    ),
                                    _buildInstallationMethod(
                                      '3.',
                                      'Once setting toggled on, Power Off the phone',
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Next button
                            Align(
                              alignment: Alignment.centerRight,
                              child: MatrixButton(
                                text: 'Next: Setup the Target',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const DeviceConnectionScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallationMethod(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: MatrixTheme.matrixGreen,
              fontSize: 16,
              fontFamily: 'Matrix',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: MatrixTheme.matrixText,
            ),
          ),
        ],
      ),
    );
  }
}
