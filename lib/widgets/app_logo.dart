import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Habitt brand logo — a rounded gradient badge with a check mark next to
/// the wordmark. Reused on the auth screens and in the home app-bar header.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 36,
    this.showWordmark = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(Icons.check_rounded, color: Colors.white, size: size * 0.62),
    );

    if (!showWordmark) return badge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(width: 10),
        Text(
          'Habitt',
          style: TextStyle(
            fontSize: size * 0.62,
            fontWeight: FontWeight.w800,
            color: textColor ?? AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
