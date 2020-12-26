import 'package:flutter/material.dart';
class PaddingElement extends StatelessWidget {
 PaddingElement({this.colorType, this.textElement, this.onFunction});
 final Color colorType;
 final String textElement; 
 final Function onFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorType,
        // 
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onFunction,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$textElement',style: TextStyle(color:Colors.white),
          ),
        ),
      ),
    );
  }
}
