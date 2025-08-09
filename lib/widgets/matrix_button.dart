import 'package:flutter/material.dart';
import 'package:smith/theme/matrix_theme.dart';

class MatrixButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  const MatrixButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<MatrixButton> createState() => _MatrixButtonState();
}

class _MatrixButtonState extends State<MatrixButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isDisabled && !widget.isLoading) {
          setState(() => _isPressed = true);
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.isDisabled && !widget.isLoading) {
          setState(() => _isPressed = false);
          _animationController.reverse();
          _handleTap(); // <-- Call the button action
        }
      },
      onTapCancel: () {
        if (!widget.isDisabled && !widget.isLoading) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isDisabled
                    ? MatrixTheme.matrixDarkGray
                    : MatrixTheme.matrixGreen,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: MatrixTheme.matrixGreen.withOpacity(
                      widget.isDisabled ? 0.0 : 0.5,
                    ),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: MatrixTheme.matrixGreen,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          MatrixTheme.matrixBlack,
                        ),
                      ),
                    ),
                  if (widget.isLoading) const SizedBox(width: 12),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.isDisabled
                          ? MatrixTheme.matrixLightGray
                          : MatrixTheme.matrixBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Matrix',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
