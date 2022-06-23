import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/constants/text_styles.dart';
import 'package:it_book_search/extensions/navigator_state.dart';
import 'package:it_book_search/models/book_preview.dart';
import 'package:it_book_search/pages/detail.dart';
import 'package:it_book_search/widgets/rich_text.dart';

class BSBookPreview extends StatelessWidget {
  final Book book;

  const BSBookPreview({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 48),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).pushRoute(DetailPage(
            book: book,
          ));
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    height: 300,
                    color: BSColors.lightBlue,
                    child: Image.network(
                      book.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.title,
                        style: BSTextStyles.title.black,
                      ),
                      if (book.subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            width: 280,
                            child: Text(
                              book.subtitle,
                              style: BSTextStyles.subtitle.black,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                          width: 280,
                          child: BSRichText(
                            '%{ISBN:} ${book.isbn13}',
                            style: BSTextStyles.caption.black.opacity(0.5),
                            variables: [
                              Variable(style: BSTextStyles.caption.black.bold)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          width: 280,
                          child: BSRichText(
                            '%{Price:} ${book.price.isEmpty ? '\$0.0' : book.price}',
                            style: BSTextStyles.subtitle.primary,
                            variables: [
                              Variable(style: BSTextStyles.subtitle.black.bold)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: BSColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
