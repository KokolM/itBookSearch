import 'dart:io';

import 'package:it_book_search/models/book_detail.dart';
import 'package:it_book_search/models/book_preview.dart';
import 'package:it_book_search/server/server.dart';

class Api {
  Future<BookPreview> getNew() async {
    return await Server.get(
      '/new',
      HttpStatus.ok,
    ).then((res) {
      return bookPreviewFromJson(res.body);
    });
  }

  Future<BookPreview> getPreviews(String expr, [int? page]) async {
    return await Server.get(
      '/search/$expr${page != null ? '/$page' : ''}',
      HttpStatus.ok,
    ).then((res) {
      return bookPreviewFromJson(res.body);
    });
  }

  Future<BookDetail> getDetail(String isbn13) async {
    return await Server.get(
      '/books/$isbn13',
      HttpStatus.ok,
    ).then((res) {
      return bookDetailFromJson(res.body);
    });
  }
}
