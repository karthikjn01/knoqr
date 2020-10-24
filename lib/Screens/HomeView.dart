import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diinq/Components/Settings.dart';
import 'package:diinq/Providers/HousesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'QRCode.dart';

class HomeView extends StatefulWidget {
  House house;

  HomeView(this.house);

  @override
  _HomeViewState createState() => _HomeViewState(this.house);
}

class _HomeViewState extends State<HomeView> {
  House _house;

  _HomeViewState(this._house);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      _house.name,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Tap");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => QRCodeGenerator(_house.code)));
                      },
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Tap");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => HomeSettings(_house)));
                      },
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).primaryColor,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSettings extends StatelessWidget {
  House _house;

  HomeSettings(this._house);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "Settings",
              style: Theme.of(context).textTheme.headline6,
            ),
            SettingComponent(
                "View Members",
                "View members in the house, add, remove, and change who get's a notification!",
                "View", () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MemberView(_house.id)));
            }),
          ],
        ),
      ),
    );
  }
}

class MemberView extends StatefulWidget {
  String houseId;

  MemberView(this.houseId);

  @override
  _MemberViewState createState() => _MemberViewState(this.houseId);
}

class _MemberViewState extends State<MemberView> {
  String houseId;
  House house;

  _MemberViewState(this.houseId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("Houses")
        .doc(houseId)
        .snapshots()
        .listen((DocumentSnapshot ds) {
      this.house = House.fromMap(ds.data(), ds.id);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {},
          label: Text("Add", style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),),
          icon: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Text(
              "Members",
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (c, i) {
                  return Container();
                },
                itemCount: house.members.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
