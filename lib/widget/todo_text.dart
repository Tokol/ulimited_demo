
import 'package:flutter/material.dart';
class TodoTextField extends StatelessWidget {
  final String hintValue;
  final Function onChanged;
  final TextInputType keyboard;
  final bool hideText;
  TodoTextField(
      {this.hintValue,
        this.onChanged,
        this.keyboard = TextInputType.text,
        this.hideText = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextField(
        keyboardType: keyboard,
        obscureText: hideText,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          hintText: hintValue,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          fillColor: Colors.white,
          filled: true,
          labelText: hintValue,

          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
