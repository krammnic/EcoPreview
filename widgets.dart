import 'package:flutter/material.dart';


class EcoTextField extends StatelessWidget {
  EcoTextField(
      {required this.hintText,
      required this.padding,
      required this.color,
      required this.icon,
      required this.submitFunction});

  final Icon icon;
  final String hintText;
  final double padding;
  final Color color;
  final submitFunction;


  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 54,
        margin: EdgeInsets.symmetric(horizontal: padding),
        padding: EdgeInsets.symmetric(horizontal: padding),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          style: TextStyle(color: color),
          autofocus: false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: color,
              fontFamily: 'Comfort'
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: icon,
          ),
          onSubmitted: (value) {
            submitFunction(value, context);
          },
        ));
  }
}
