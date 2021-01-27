import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  // for single route
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  // for all pages
  @override
  Widget buildTransitions<T>(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
