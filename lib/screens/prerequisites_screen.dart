import 'package:flutter/material.dart';
import 'package:smith/screens/target_setting_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/widgets/digital_rain_animation.dart';
import 'package:smith/widgets/matrix_button.dart';

class PrerequisitesScreen extends StatefulWidget {
  const PrerequisitesScreen({super.key});

  @override
  State<PrerequisitesScreen> createState() => _PrerequisitesScreenState();
}

class _PrerequisitesScreenState extends State<PrerequisitesScreen>
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MatrixTheme.matrixDarkGray,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: MatrixTheme.matrixGreen,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: MatrixTheme.matrixGreen,
                              size: 20,
                            ),
                          ),
                        ),

                        // Step number in the center
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
                            'Step 1 of 6',
                            style: MatrixTheme.matrixText,
                          ),
                        ),

                        // Next button (styled like the step container)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => const TargetSettingScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MatrixTheme.matrixDarkGray,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: MatrixTheme.matrixGreen,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: MatrixTheme.matrixGreen,
                              size: 20,
                            ),
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
                              'PREREQUISITES',
                              style: MatrixTheme.matrixHeading,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Supported devices section
                            const Text(
                              'WHAT DEVICES ARE SUPPORTED BY SLATE OS:',
                              style: TextStyle(
                                color: MatrixTheme.matrixGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Matrix',
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            const Text(
                              'Pixel 7a, Pixel 8, Pixel 8a, Pixel 8pro, Pixel 9a',
                              style: MatrixTheme.matrixText,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            const Text(
                              'You can Flash a new SlateOS Phone from the following devices and systems:',
                              style: MatrixTheme.matrixText,
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
                                      'SlateOS - Via Vanadium Browser',
                                    ),
                                    _buildInstallationMethod(
                                      '2.',
                                      'GrapheneOS - Via Vanadium',
                                    ),
                                    _buildInstallationMethod(
                                      '3.',
                                      'Stock Android - Via Chrome Browser',
                                    ),
                                    _buildInstallationMethod(
                                      '4.',
                                      'Mac PC - Via Chrome Browser (NON INCOGNITO MODE)',
                                    ),
                                    _buildInstallationMethod(
                                      '5.',
                                      'Windows PC - Via Chrome Browser (NON INCOGNITO MODE)',
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
                                      builder: (context) => const TargetSettingScreen(),
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
