import 'package:diinq/Providers/UserData.dart';
import 'package:flutter/material.dart';

class HouseCard extends StatelessWidget {
  House house;
  Function onTap;

  HouseCard(this.house, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
              style: BorderStyle.solid),
        ),
        child: Center(
          child: Text(
            house.name,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
