import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';

class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;

  final Color bg;
  final Color fg;

  final double height;
  final double borderRadius;
  final double elevation;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? boxShadow;

  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
    this.bg = Colors.white,
    this.fg = const Color(0xFF474747),
    this.height = 48,
    this.borderRadius = 18,
    this.elevation = 4,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = !enabled || onTap == null;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: (borderColor ?? Colors.grey.shade300),
        width: borderWidth,
      ),
    );

    return Material(
      color: disabled ? Colors.grey.shade300 : bg,
      elevation: elevation,
      shadowColor: Colors.black26,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: disabled ? null : onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: boxShadow,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: robotoBold,
              fontSize: 16,
              color: disabled ? Colors.white70 : fg,
              letterSpacing: .2,
              fontWeight: FontWeight.w700, // bold visible
            ),
          ),
        ),
      ),
    );
  }
}