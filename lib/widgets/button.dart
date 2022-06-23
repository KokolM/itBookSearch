import 'package:flutter/material.dart';
import 'package:it_book_search/constants/colors.dart';
import 'package:it_book_search/constants/text_styles.dart';
import 'package:it_book_search/widgets/loading.dart';

class BSButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool loading;

  const BSButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 400,
          ),
          child: Container(
            color: BSColors.purple,
            child: Padding(
              padding: EdgeInsets.fromLTRB(icon != null ? 16 : 32, 16, 32, 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        icon!,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  loading
                      ? const BSLoading(
                          size: 18,
                          color: Colors.white,
                        )
                      : Text(
                          text,
                          style: BSTextStyles.body,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
