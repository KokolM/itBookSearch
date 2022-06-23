import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/extensions/navigator_state.dart';
import 'package:it_book_search/pages/search.dart';
import 'package:it_book_search/widgets/logo.dart';
import 'package:it_book_search/widgets/search_area.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _visible = true;

  _hideLogo() {
    setState(() {
      _visible = false;
    });
  }

  _showLogo() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  _onTap() {
    _hideLogo();
    Navigator.of(context)
        .pushRoute(
          const SearchPage(),
          pageAnimation: BSPageAnimation.fade,
        )
        .then((_) => _showLogo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BSColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: const BSLogo(),
            ),
            const SizedBox(height: 16),
            Hero(
              tag: 'search-field',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BSSearchArea(
                  readOnly: true,
                  onTap: _onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
