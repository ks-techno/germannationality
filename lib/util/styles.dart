import 'package:google_fonts/google_fonts.dart';
import 'dimensions.dart';
import 'package:flutter/material.dart';

final ralewayRegular = GoogleFonts.raleway(
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);
final ralewayHeading = GoogleFonts.raleway(
  fontWeight: FontWeight.w700,
  fontSize: 30,
  color: Colors.black
);
final ralewaySubHeading = GoogleFonts.raleway(
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeLarge,
  color: Color(0xff989d9e)
);

final ralewayMedium = TextStyle(
  fontFamily: 'ralewayMedium',
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault,
);
final ralewaySemiBold = GoogleFonts.raleway(
  fontWeight: FontWeight.w500,
  
  fontSize: Dimensions.fontSizeDefault,
);
final ralewayBold = GoogleFonts.raleway(
  fontWeight: FontWeight.w700,
  fontSize: Dimensions.fontSizeDefault,
);

