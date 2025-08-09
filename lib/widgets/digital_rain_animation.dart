import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smith/theme/matrix_theme.dart';

class DigitalRainAnimation extends StatefulWidget {
  const DigitalRainAnimation({super.key});

  @override
  State<DigitalRainAnimation> createState() => _DigitalRainAnimationState();
}

class _DigitalRainAnimationState extends State<DigitalRainAnimation> {
  late Timer _timer;
  final List<RainDrop> _rainDrops = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          // Add new raindrops
          if (_rainDrops.length < 50) {
            _rainDrops.add(RainDrop(
              x: _random.nextDouble() * 400,
              y: -20,
              speed: 2 + _random.nextDouble() * 3,
              length: 10 + _random.nextInt(20),
            ));
          }

          // Update existing raindrops
          for (int i = _rainDrops.length - 1; i >= 0; i--) {
            final drop = _rainDrops[i];
            drop.y += drop.speed;
            
            // Remove drops that are off screen
            if (drop.y > 800) {
              _rainDrops.removeAt(i);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DigitalRainPainter(_rainDrops),
      size: Size.infinite,
    );
  }
}

class DigitalRainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;

  DigitalRainPainter(this.rainDrops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MatrixTheme.matrixGreen.withOpacity(0.3)
      ..strokeWidth = 1.0;

    for (final drop in rainDrops) {
      final path = Path();
      path.moveTo(drop.x, drop.y);
      path.lineTo(drop.x, drop.y + drop.length);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RainDrop {
  double x;
  double y;
  final double speed;
  final int length;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });
}
