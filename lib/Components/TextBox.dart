import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextBox extends StatelessWidget {
  TextEditingController _editingController;
  String hint;
  bool conceal;

  TextBox(this._editingController, this.hint, {this.conceal = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
          child: Text(
            hint,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).dividerColor,
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _editingController,
            obscureText: this.conceal,
            cursorWidth: 5.0,
            cursorColor: Theme.of(context).primaryColor,
            cursorRadius: Radius.circular(2.5),
            enableInteractiveSelection: false,

            decoration: InputDecoration(
                border: InputBorder.none,
                filled: false,
                fillColor: Theme.of(context).dividerColor,
                alignLabelWithHint: false),
          ),
        ),
      ],
    );
  }
}
