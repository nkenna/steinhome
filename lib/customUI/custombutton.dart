import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
 final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.redAccent,
        child: MaterialButton(
          
          onPressed: callback,
          minWidth: 200.0,
          height: 45.0,
          child: Text(text),
        ),
      ),
    );
  }
}
