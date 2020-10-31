import 'package:diinq/Components/Button.dart';
import 'package:diinq/Components/TextBox.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class PopUp {
  static void errorPop(String title, String description, context) {
    Flushbar(
      titleText: Text(
        title,
        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 24),
      ),
      messageText: Text(
        description,
        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      boxShadows: [
        BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            spreadRadius: 10.0)
      ],
      margin: EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
      borderRadius: 20.0,
      padding: EdgeInsets.all(20.0),
      duration: Duration(seconds: 2),
      isDismissible: false,
    ).show(context);
  }

  static void fullScreenPopUp(
      String title,
      String description,
      String button,
      Function(TextEditingController) onConfirm,
      Function(String) isValid,
      context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        TextEditingController _houseName = TextEditingController();
        return StatefulBuilder(builder: (key, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(description),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextBox(_houseName, title),
                  ),
                  ThicButton(
                    button,
                    () {
                      if (isValid(_houseName.value.text)) {
                        onConfirm(_houseName);
                      }else{
                        PopUp.errorPop("Please Enter a valid value", "The text provided was invalid", context);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void confirm(String title, String description, String confirmButton,
      String cancelButton, Function onConfirm, Function onCancel, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(description),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: ThicButton(
                    confirmButton,
                    () {
                      onConfirm();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThicButton(
                    cancelButton,
                    () {
                      onCancel();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
