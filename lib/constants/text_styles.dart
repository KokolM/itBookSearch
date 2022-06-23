import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';

extension TextStyleExtension on TextStyle {
  TextStyle opacity(double opacity) {
    var c = color ?? Colors.white;
    int r = c.red;
    int g = c.green;
    int b = c.blue;
    return copyWith(
      color: Color.fromRGBO(r, g, b, opacity),
    );
  }

  TextStyle size(double size) {
    return copyWith(
      fontSize: size,
    );
  }

  TextStyle get black => copyWith(color: Colors.black);

  TextStyle get primary => copyWith(color: BSColors.primary);

  TextStyle get regular => copyWith(fontWeight: FontWeight.w500);

  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
}

class BSTextStyles {

  //TITLE
  static const title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.375,
  );

  //TITLE-LIGHT
  static const subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.375,
  );

  //BODY
  static const body = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.474,
  );

  //CAPTION
  static const caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.471,
  );

  //CLICKABLE
  static const clickable = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}