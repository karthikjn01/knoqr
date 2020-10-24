import 'package:diinq/Components/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingComponent extends StatelessWidget {
  String title, cap, button;
  Function onClick;

  SettingComponent(this.title, this.cap, this.button, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 20.0),
                ),
                Text(
                  cap,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Button(button, onClick),
          )
        ],
      ),
    );
  }
}
