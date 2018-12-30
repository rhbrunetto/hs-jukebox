import 'package:flutter/material.dart';

class DiamondBorder extends ShapeBorder {

  final bool up;

  const DiamondBorder({this.up});

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    final offsetlist = up ?
    [rect.bottomLeft, rect.topCenter, rect.bottomRight] :
    [rect.topLeft, rect.bottomCenter, rect.topRight];

    return Path()
      ..addPolygon(offsetlist, true);
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}