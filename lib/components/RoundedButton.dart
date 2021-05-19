import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.buttonTitle,this.buttonBG,this.onPressed});
  final Function onPressed;
  final Color buttonBG;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonBG,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
