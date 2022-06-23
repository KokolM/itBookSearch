import 'package:flutter/material.dart';
import 'package:it_book_search/pages/home.dart';
import 'package:it_book_search/widgets/icon_button.dart';

class BSHomeButton extends StatelessWidget {
  const BSHomeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BSIconButton(
      size: 64,
      iconSize: 36,
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomePage()),
          (route) => route.isFirst,
        );
      },
      icon: Icons.home,
      rounded: true,
    );
  }
}
