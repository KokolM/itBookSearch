import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:it_book_search/constants/text_styles.dart';

class Variable {
  final TextStyle? style;
  final Function? onTap;
  final String? replacementText;
  final Widget? replacementWidget;

  Variable({
    this.style,
    this.onTap,
    this.replacementText,
    this.replacementWidget,
  });
}

class BSRichText extends StatelessWidget {
  final String text;
  final List<Variable> variables;
  final TextStyle? style;
  final TextAlign? textAlign;
  final VoidCallback? constantTextOnTap;

  final List<InlineSpan> _spans = List<InlineSpan>.empty(growable: true);

  _addText(String text, TextStyle? style, Function()? onTap) {
    var gestureRecognizer = TapGestureRecognizer();
    gestureRecognizer.onTap = onTap ?? constantTextOnTap;
    _spans.add(
      TextSpan(
        text: text,
        style: style ?? BSTextStyles.body.black,
        recognizer: gestureRecognizer.onTap != null ? gestureRecognizer : null,
      ),
    );
  }

  _addVariableText(String? text, Variable variable) {
    _addText(
      variable.replacementText ?? text ?? '',
      variable.style ?? BSTextStyles.body.black,
      variable.onTap as GestureTapCallback?,
    );
  }

  _addVariableWidget(Variable variable) {
    _spans.add(
      WidgetSpan(child: variable.replacementWidget!),
    );
  }

  _addVariable(RegExpMatch match, int index) {
    var text = match.group(1);
    if (variables.length > index) {
      if (variables[index].replacementWidget != null) {
        _addVariableWidget(variables[index]);
      } else {
        _addVariableText(text, variables[index]);
      }
    }
  }

  _addConstant(String text) {
    _addText(text, style, constantTextOnTap);
  }

  _parse(List<String> constantText, Iterable<RegExpMatch> matches) {
    int i = 0;
    for (var match in matches) {
      _addConstant(constantText[0]);
      constantText.removeAt(0);
      _addVariable(match, i);
      i++;
    }
    while (constantText.isNotEmpty) {
      _addConstant(constantText[0]);
      constantText.removeAt(0);
    }
  }

  BSRichText(
    this.text, {
    Key? key,
    required this.variables,
    this.style,
    this.textAlign,
    this.constantTextOnTap,
  }) : super(key: key) {
    var outerRegExp = RegExp(r'(\%\{.*?\})');
    var innerRegExp = RegExp(r'\%\{(.*?)\}');

    var constantText = text.split(outerRegExp);
    var matches = innerRegExp.allMatches(text);
    _parse(constantText, matches);

    if (_spans.isEmpty) {
      _addConstant(constantText[0]);
    }
    // to patch known issue with gesture recognizer taking up all
    // remaining space in text line
    _spans.add(const TextSpan(
      text: ' ',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style ?? BSTextStyles.body.black,
        children: _spans,
      ),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
