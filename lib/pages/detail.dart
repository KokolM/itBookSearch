import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/constants/text_styles.dart';
import 'package:it_book_search/models/book_detail.dart';
import 'package:it_book_search/models/book_preview.dart';
import 'package:it_book_search/server/api.dart';
import 'package:it_book_search/widgets/button.dart';
import 'package:it_book_search/widgets/home_button.dart';
import 'package:it_book_search/widgets/loading.dart';
import 'package:it_book_search/widgets/logo.dart';
import 'package:it_book_search/widgets/rich_text.dart';
import 'package:url_launcher/url_launcher.dart';

class _Rating extends StatelessWidget {
  final int stars;

  const _Rating({
    Key? key,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            stars,
            (index) => const Icon(
              Icons.star,
              color: BSColors.yellow,
            ),
          ),
          ...List.generate(
            5 - stars,
            (index) => const Icon(
              Icons.star,
              color: BSColors.grey,
            ),
          ),
        ]);
  }
}

class _Detail extends StatefulWidget {
  final Book book;

  const _Detail({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<_Detail> createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  final _api = Api();

  bool _loading = false;
  late final BookDetail _detail;

  _downloadDetail() async {
    setState(() {
      _loading = true;
    });
    _detail = await _api.getDetail(widget.book.isbn13);
    setState(() {
      _loading = false;
    });
  }

  _goToStore() async {
    Uri uri = Uri.parse(_detail.url);
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }

  @override
  void initState() {
    super.initState();
    _downloadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: BSLoading(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Rating(stars: int.tryParse(_detail.rating) ?? 0),
              const SizedBox(height: 8),
              Text(
                _detail.title,
                style: BSTextStyles.title.black,
              ),
              if (_detail.subtitle.isNotEmpty)
                Text(
                  _detail.subtitle,
                  style: BSTextStyles.subtitle.black,
                ),
              const SizedBox(height: 4),
              BSRichText(
                '%{ISBN:} ${_detail.isbn13}',
                style: BSTextStyles.caption.black.opacity(0.5),
                variables: [Variable(style: BSTextStyles.caption.black.bold)],
              ),
              const SizedBox(height: 16),
              if (_detail.authors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: BSRichText(
                    '%{Authors:} ${_detail.authors}',
                    style: BSTextStyles.subtitle.black,
                    variables: [
                      Variable(style: BSTextStyles.subtitle.black.bold),
                    ],
                  ),
                ),
              if (_detail.publisher.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: BSRichText(
                    '%{Publisher:} ${_detail.publisher}',
                    style: BSTextStyles.subtitle.black,
                    variables: [
                      Variable(style: BSTextStyles.subtitle.black.bold),
                    ],
                  ),
                ),
              if (_detail.pages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: BSRichText(
                    '%{Pages:} ${_detail.pages}',
                    style: BSTextStyles.subtitle.black,
                    variables: [
                      Variable(style: BSTextStyles.subtitle.black.bold),
                    ],
                  ),
                ),
              if (_detail.year.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: BSRichText(
                    '%{Year:} ${_detail.year}',
                    style: BSTextStyles.subtitle.black,
                    variables: [
                      Variable(style: BSTextStyles.subtitle.black.bold),
                    ],
                  ),
                ),
              if (_detail.desc.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: BSRichText(
                    '%{Description:} ${_detail.desc}',
                    style: BSTextStyles.body.black.opacity(0.8),
                    variables: [
                      Variable(style: BSTextStyles.body.black.bold),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              BSRichText(
                '%{Price:} ${_detail.price.isEmpty ? '\$0.0' : _detail.price}',
                style: BSTextStyles.subtitle.primary,
                variables: [Variable(style: BSTextStyles.subtitle.black.bold)],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BSButton(
                  text: 'Go to store',
                  onTap: _goToStore,
                ),
              ),
              const SizedBox(height: 128),
            ],
          );
  }
}

class DetailPage extends StatelessWidget {
  final Book book;

  const DetailPage({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BSColors.secondary,
      floatingActionButton: const BSHomeButton(),
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
        child: ListView(
          children: [
            Image.network(
              book.image,
              fit: BoxFit.cover,
              height: 400,
              width: size.width,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Detail(
                book: book,
              ),
            )
          ],
        ),
      ),
    );
  }
}
