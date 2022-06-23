import 'package:flutter/cupertino.dart';

enum BSPageAnimation {
  cupertino,
  fade,
  noAnimation,
  cupertinoNoForward,
}

extension BSNavigatorState on NavigatorState {
  Duration _transitionDuration(pageAnimation) {
    return Duration(
      milliseconds: pageAnimation == BSPageAnimation.noAnimation ||
              pageAnimation == BSPageAnimation.cupertinoNoForward
          ? 0
          : 300,
    );
  }

  Duration _reverseTransitionDuration(pageAnimation) {
    return Duration(
      milliseconds: pageAnimation == BSPageAnimation.noAnimation ? 0 : 300,
    );
  }

  Widget _builder(pageAnimation, animation, secondaryAnimation, child) {
    if (pageAnimation == BSPageAnimation.noAnimation) {
      return child;
    }

    switch (pageAnimation) {
      case BSPageAnimation.fade:
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      case BSPageAnimation.cupertinoNoForward:
        return animation.status == AnimationStatus.reverse
            ? CupertinoPageTransition(
                linearTransition: true,
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                child: child,
              )
            : child;
      default:
        return child;
    }
  }

  Future<T?> pushRoute<T extends Object?>(
    Widget nextPage, {
    BSPageAnimation pageAnimation = BSPageAnimation.cupertino,
    bool opaque = true,
  }) {
    return pageAnimation != BSPageAnimation.cupertino
        ? push(
            PageRouteBuilder(
              opaque: opaque,
              pageBuilder: (context, animation, secondaryAnimation) => nextPage,
              transitionDuration: _transitionDuration(pageAnimation),
              reverseTransitionDuration: _reverseTransitionDuration(
                pageAnimation,
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return _builder(
                  pageAnimation,
                  animation,
                  secondaryAnimation,
                  child,
                );
              },
            ),
          )
        : push(
            CupertinoPageRoute(
              builder: (context) => nextPage,
            ),
          );
  }
}
