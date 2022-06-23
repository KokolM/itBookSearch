import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';

class BSIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final bool rounded;

  const BSIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = BSColors.purple,
    this.size = 48,
    this.iconSize = 24,
    this.rounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: rounded
                ? const BorderRadius.all(Radius.circular(1000))
                : BorderRadius.zero),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
