import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/widgets/logo.dart';
import 'package:it_book_search/widgets/search_area.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BSColors.secondary,
      appBar: AppBar(
        title: const BSLogo(),
        backgroundColor: BSColors.primary,
        toolbarHeight: 72,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Hero(
          tag: 'search-field',
          child: BSSearchArea(),
        ),
      ),
    );
  }
}
