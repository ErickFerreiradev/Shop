import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  const Badgee({required this.child, required this.value, this.color, super.key,});

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            child: Text(value),
          )
          ),
      ],
    );
  }
}