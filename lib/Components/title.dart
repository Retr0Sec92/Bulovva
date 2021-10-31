import 'package:bulovva/Constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'My',
              style: GoogleFonts.amaticSc(
                color: ColorConstants.instance.whiteContainer,
              )),
          TextSpan(
              text: 'Rest',
              style: GoogleFonts.amaticSc(
                color: ColorConstants.instance.whiteContainer,
              )),
          TextSpan(
              text: 'App',
              style: GoogleFonts.amaticSc(
                color: ColorConstants.instance.textGold,
              )),
        ]));
  }
}