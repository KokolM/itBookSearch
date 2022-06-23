import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';

class BSLoading extends StatelessWidget {
  final double? size;
  final Color? color;

  const BSLoading({
    Key? key,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 48,
      width: size ?? 48,
      child: CircularProgressIndicator(
        color: color ?? BSColors.purple,
      ),
    );
  }
}
