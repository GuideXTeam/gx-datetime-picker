import 'package:flutter/material.dart';

class ItemTheme {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Widget? title;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? fadeFromColor;
  final Color? fadeToColor;
  final Decoration? selectorDecoration;

  const ItemTheme({
    this.width,
    this.height,
    this.backgroundColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.title,
    this.padding,
    this.margin,
    this.fadeFromColor,
    this.fadeToColor,
    this.selectorDecoration,
  });
}
