


import 'package:flutter/material.dart';

class MyColors{
  static const  Color darkGreen =   Color(0xff003B00);
  static const  Color dark =   Color(0xff0D0208);
  static const  Color white =   Colors.white;
  static const  Color green =   Color(0xff008F11);
  static const  Color lightGreen =   Color(0xff00FF41);
}


class Styles {

  static TextStyle matrix(double fontSize){
    return TextStyle(fontFamily: "matrix",fontSize:fontSize,color: MyColors.lightGreen );
  }

  static TextStyle normal(double fontSize){
    return TextStyle(fontSize:fontSize,color: MyColors.lightGreen );
  }

}

extension ResponsiveHelper on BuildContext {
  double width(double val) => MediaQuery.of(this).size.width * val;

  double height(double val) => MediaQuery.of(this).size.height * val;
}

class Spaces {
  Spaces._();

  //vertical
  static SizedBox get vertical3 => const SizedBox(height: 3);

  static SizedBox get vertical5 => const SizedBox(height: 5);

  static SizedBox get vertical10 => const SizedBox(height: 10);

  static SizedBox get vertical15 => const SizedBox(height: 15);

  static SizedBox get vertical20 => const SizedBox(height: 20);

  static SizedBox get vertical25 => const SizedBox(height: 25);

  //horizontal

  static SizedBox get horizontal3 => const SizedBox(width: 3);

  static SizedBox get horizontal5 => const SizedBox(width: 5);

  static SizedBox get horizontal10 => const SizedBox(width: 10);

  static SizedBox get horizontal15 => const SizedBox(width: 15);

  static SizedBox get horizontal20 => const SizedBox(width: 20);
}

class Paddings {
  Paddings._();

  static EdgeInsets get padding3 => const EdgeInsets.all(3);

  static EdgeInsets get padding8 => const EdgeInsets.all(8);

  static EdgeInsets get padding12 => const EdgeInsets.all(12);

  static EdgeInsets get padding15 => const EdgeInsets.all(15);

  static EdgeInsets get padding20 => const EdgeInsets.all(20);

  static EdgeInsets get padding25 => const EdgeInsets.all(25);
}
