import 'package:flutter/material.dart';
import 'package:it_book_search/constants/text_styles.dart';

class _Decoration extends InputDecoration {
  _Decoration(String? hint): super(
    fillColor: Colors.white,
    filled: true,
    border: InputBorder.none,
    hintText: hint,
    hintStyle: BSTextStyles.body.black.opacity(0.5)
  );
}

class BSTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? hint;

  const BSTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: _Decoration(hint),
        onTap: onTap,
        readOnly: readOnly,
        autofocus: false,
        style: BSTextStyles.body.black,
      ),
    );
  }
}
