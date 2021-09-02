import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GradientButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String buttonText;
  final Color startColor;
  final Color finishColor;
  final Color fontColor;
  final Color iconColor;
  final String fontFamily;
  final double fontSize;
  final double widthMultiplier;

  const GradientButton(
      {Key key,
      this.onPressed,
      this.icon,
      this.startColor,
      this.finishColor,
      this.buttonText,
      this.fontFamily,
      this.fontColor,
      this.fontSize,
      this.iconColor,
      this.widthMultiplier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * this.widthMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(colors: [
            this.startColor,
            this.finishColor,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
      child: TextButton(
        onPressed: this.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              this.icon,
              color: this.iconColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(this.buttonText,
                  style: TextStyle(
                      fontFamily: this.fontFamily,
                      fontSize: this.fontSize,
                      color: this.fontColor)),
            ),
          ],
        ),
      ),
    );
  }
}