import 'dart:convert';

BookDetail bookDetailFromJson(String str) =>
    BookDetail.fromJson(json.decode(str));

class BookDetail {
  BookDetail({
    required this.error,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.publisher,
    required this.isbn10,
    required this.isbn13,
    required this.pages,
    required this.year,
    required this.rating,
    required this.desc,
    required this.price,
    required this.image,
    required this.url,
    required this.pdf,
  });

  String error;
  String title;
  String subtitle;
  String authors;
  String publisher;
  String isbn10;
  String isbn13;
  String pages;
  String year;
  String rating;
  String desc;
  String price;
  String image;
  String url;
  Map<String, dynamic>? pdf;

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
        error: json["error"],
        title: json["title"],
        subtitle: json["subtitle"],
        authors: json["authors"],
        publisher: json["publisher"],
        isbn10: json["isbn10"],
        isbn13: json["isbn13"],
        pages: json["pages"],
        year: json["year"],
        rating: json["rating"],
        desc: json["desc"],
        price: json["price"],
        image: json["image"],
        url: json["url"],
        pdf: json["pdf"],
      );
}
