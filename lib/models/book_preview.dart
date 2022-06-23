import 'dart:convert';

BookPreview bookPreviewFromJson(String str) =>
    BookPreview.fromJson(json.decode(str));

class BookPreview {
  BookPreview({
    required this.total,
    required this.page,
    required this.books,
  });

  String total;
  String? page;
  List<Book> books;

  factory BookPreview.fromJson(Map<String, dynamic> json) => BookPreview(
        total: json["total"],
        page: json["page"],
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
      );
}

class Book {
  Book({
    required this.title,
    required this.subtitle,
    required this.isbn13,
    required this.price,
    required this.image,
    required this.url,
  });

  String title;
  String subtitle;
  String isbn13;
  String price;
  String image;
  String url;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        title: json["title"],
        subtitle: json["subtitle"],
        isbn13: json["isbn13"],
        price: json["price"],
        image: json["image"],
        url: json["url"],
      );
}
