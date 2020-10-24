import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonCard extends StatelessWidget {
  String name;
  Function onClick;

  PersonCard(this.name, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$name",
            style: Theme.of(context).textTheme.caption,
          ),
          GestureDetector(
            onTap: onClick,
            child: Container(
              height: 20,
              width: 20,
              child: Icon(
                Icons.remove,
                color: Colors.redAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
