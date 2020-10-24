import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginSignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Center(child: Text("Baddle")),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    ));
  }
}
