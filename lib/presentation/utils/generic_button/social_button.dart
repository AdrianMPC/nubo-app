import 'package:flutter/material.dart';

/// Botón social
class SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade300, width: 1),
    );

    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5B5B5B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
