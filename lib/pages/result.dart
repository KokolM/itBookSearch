import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/constants/text_styles.dart';
import 'package:it_book_search/models/book_preview.dart';
import 'package:it_book_search/server/api.dart';
import 'package:it_book_search/widgets/book_preview.dart';
import 'package:it_book_search/widgets/button.dart';
import 'package:it_book_search/widgets/home_button.dart';
import 'package:it_book_search/widgets/icon_button.dart';
import 'package:it_book_search/widgets/logo.dart';

class _NoResult extends StatelessWidget {
  const _NoResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No results',
            style: BSTextStyles.title.black,
          ),
          const SizedBox(height: 8),
          Align(
            child: BSButton(
              text: 'Change search',
              icon: Icons.search,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final String searchExpression;
  final BookPreview result;

  const ResultPage({
    Key? key,
    required this.searchExpression,
    required this.result,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _api = Api();
  final ScrollController _scrollController = ScrollController();

  late List<Book> _allResults;
  late int _total;
  late int _page;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _allResults = [...widget.result.books];
    _total = int.tryParse(widget.result.total) ?? 0;
    _page = int.tryParse(widget.result.page ?? '1')!;
  }

  _eol() {
    return _allResults.length % _total == 0;
  }

  _loadMore() async {
    setState(() {
      _loading = true;
    });
    var preview = await _api.getPreviews(widget.searchExpression, _page + 1);
    setState(() {
      _page++;
      _allResults.addAll(preview.books);
      _total = int.tryParse(preview.total) ?? _total;
      _loading = false;
    });
  }

  _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BSColors.secondary,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BSIconButton(
            onTap: _scrollToTop,
            icon: Icons.arrow_upward,
            rounded: true,
          ),
          const SizedBox(height: 8),
          const BSHomeButton()
        ],
      ),
      appBar: AppBar(
        title: const BSLogo(),
        backgroundColor: BSColors.primary,
        toolbarHeight: 72,
        elevation: 0,
      ),
      body: Container(
        color: BSColors.lightBlue,
        width: size.width,
        height: size.height,
        child: _allResults.isEmpty
            ? const _NoResult()
            : ListView.builder(
                controller: _scrollController,
                itemCount: _allResults.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BSBookPreview(
                          book: _allResults[index],
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: BSColors.primary.withOpacity(0.2),
                      ),
                      if (index == _allResults.length - 1 && !_eol())
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 64),
                          child: BSButton(
                            text: 'Load more',
                            onTap: _loadMore,
                            loading: _loading,
                          ),
                        )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
