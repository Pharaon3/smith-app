import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith/providers/flash_provider.dart';
import 'package:smith/providers/device_provider.dart';
import 'package:smith/screens/welcome_screen.dart';
import 'package:smith/theme/matrix_theme.dart';
import 'package:smith/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.init();
  
  runApp(const SmithFlasherApp());
}

class SmithFlasherApp extends StatelessWidget {
  const SmithFlasherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => FlashProvider()),
      ],
      child: MaterialApp(
        title: 'Smith Flasher',
        theme: MatrixTheme.darkTheme,
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
