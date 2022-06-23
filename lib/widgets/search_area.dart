import 'dart:async';

import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/constants/text_styles.dart';
import 'package:it_book_search/extensions/navigator_state.dart';
import 'package:it_book_search/models/book_preview.dart';
import 'package:it_book_search/pages/result.dart';
import 'package:it_book_search/server/api.dart';
import 'package:it_book_search/widgets/icon_button.dart';
import 'package:it_book_search/widgets/loading.dart';
import 'package:it_book_search/widgets/text_field.dart';
import 'package:provider/provider.dart';

class _SuggestionsProvider with ChangeNotifier {
  List<Book>? _books;

  List<Book>? get suggestions => _books;

  set suggestions(List<Book>? books) {
    _books = books;
    notifyListeners();
  }

  void clear() {
    if (_books != null) {
      _books = null;
      notifyListeners();
    }
  }
}

class _Suggestion extends StatelessWidget {
  final Book book;

  const _Suggestion({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              color: BSColors.lightBlue,
              child: Image.network(
                book.image,
              ),
            ),
            const SizedBox(width: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: Text(
                book.title,
                style: BSTextStyles.body.primary,
              ),
            ),
            const Expanded(child: SizedBox(width: 10)),
            const Icon(
              Icons.keyboard_arrow_right,
              color: BSColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 1,
          color: BSColors.lightBlue,
        )
      ],
    );
  }
}

typedef OnSuggestionSelect = Function(String);

class _Suggestions extends StatelessWidget {
  final List<Book> initialSuggestions;
  final OnSuggestionSelect onSuggestionSelect;

  const _Suggestions({
    Key? key,
    required this.onSuggestionSelect,
    required this.initialSuggestions,
  }) : super(key: key);

  Widget _buildSuggestion(Book book) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onSuggestionSelect(book.title);
      },
      child: _Suggestion(
        book: book,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (_) {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
              child: Consumer<_SuggestionsProvider>(
                  builder: (context, provider, _) {
                var suggestions = provider.suggestions ?? initialSuggestions;
                return suggestions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No matches found',
                          style: BSTextStyles.body.black,
                        ),
                      )
                    : Column(
                        children: suggestions
                            .map((e) => _buildSuggestion(e))
                            .toList(),
                      );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class BSSearchArea extends StatefulWidget {
  final VoidCallback? onTap;
  final bool readOnly;

  const BSSearchArea({
    Key? key,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<BSSearchArea> createState() => _BSSearchAreaState();
}

class _BSSearchAreaState extends State<BSSearchArea> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _SuggestionsProvider _suggestionsProvider = _SuggestionsProvider();
  final _api = Api();

  bool _selectFromSuggestions = false;
  String _lastSearchExpr = '';

  bool _loading = false;
  List<Book>? _initialSuggestions;

  _requestFocus() async {
    if (!widget.readOnly) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _focusNode.requestFocus();
      }
    }
  }

  _updatePreviews(String expr) async {
    var selectFromSuggestions = _selectFromSuggestions;
    var preview = await _api.getPreviews(expr);
    if (selectFromSuggestions && mounted) {
      Navigator.of(context).pushRoute(ResultPage(
        searchExpression: expr,
        result: preview,
      ));
    } else {
      _suggestionsProvider.suggestions = preview.books;
    }
  }

  _listenForInputChange() {
    if (!widget.readOnly) {
      _controller.addListener(() {
        var expr = _controller.text;
        if (_lastSearchExpr != expr) {
          if (expr.length >= 3) {
            _updatePreviews(expr);
          } else {
            _suggestionsProvider.clear();
          }
        }
        _lastSearchExpr = expr;
      });
    }
  }

  _moveCursorToTheEnd() {
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  _onSuggestionSelect(String title) {
    _selectFromSuggestions = true;
    _lastSearchExpr = '';
    _controller.text = title;
    _moveCursorToTheEnd();
    _selectFromSuggestions = false;
  }

  _search() async {
    var preview = await _api.getPreviews(_controller.text);
    if (mounted) {
      Navigator.of(context).pushRoute(ResultPage(
        searchExpression: _controller.text,
        result: preview,
      ));
    }
  }

  _getNew() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    var preview = await _api.getNew();
    if (mounted) {
      _initialSuggestions = preview.books;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestFocus();
    _listenForInputChange();
    _getNew();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: BSTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    readOnly: widget.readOnly,
                    onTap: widget.onTap,
                    hint: 'Search books by title, author, ISBN or keywords',
                  ),
                ),
                const SizedBox(width: 8),
                BSIconButton(
                  onTap: widget.onTap ?? _search,
                  icon: Icons.search,
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!widget.readOnly)
            Expanded(
              child: ChangeNotifierProvider(
                create: (_) => _suggestionsProvider,
                child: _loading
                    ? const Center(
                        child: BSLoading(),
                      )
                    : _initialSuggestions == null
                        ? Container()
                        : _Suggestions(
                            onSuggestionSelect: _onSuggestionSelect,
                            initialSuggestions: _initialSuggestions!,
                          ),
              ),
            ),
        ],
      ),
    );
  }
}
