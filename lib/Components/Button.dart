import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThicButton extends StatelessWidget {
  String text;
  Function onClick;

  ThicButton(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 60.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Center(
            child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        )),
      ),
    );
  }
}

class Button extends StatelessWidget {
  String text;
  Function onClick;

  Button(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.button.copyWith(fontSize: 14.0),
            )),
      ),
    );
  }
}

