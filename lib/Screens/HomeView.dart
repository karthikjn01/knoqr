import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diinq/Components/MessageCard.dart';
import 'package:diinq/Components/PersonCard.dart';
import 'package:diinq/Components/PopUp.dart';
import 'package:diinq/Components/Settings.dart';
import 'package:diinq/Providers/Auth.dart';
import 'package:diinq/Providers/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
    Provider.of<Auth>(context, listen: false).context = context;
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
                            builder: (_) => QRCodeGenerator(_house)));
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
                    _house.owner ==
                            Provider.of<Auth>(context, listen: false).user.email
                        ? GestureDetector(
                            onTap: () {
                              print("Tap");
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => HomeSettings(_house)))
                                  .then((value) {
                                _house.update().then((v) {
                                  setState(() {
                                    _house = v;
                                    print(
                                        "HOUSE WAS UPDATED - HERE IS THE CODE: ${_house.code}");
                                  });
                                });
                              });
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
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            Text(
              "Here are the last 10 messages:",
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (c, i) {
                  return MessageCard(_house.messages[i]);
                },
                itemCount: _house.messages.length,
              ),
            )
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
            SettingComponent(
                "Generate New Code", "Generate a new QR code", "Generate", () {
              PopUp.confirm(
                  "Generate new QR Code",
                  "This means that a new QR code will be generated, please reprint the new QR code",
                  "Yep Regenerate",
                  "Cancel", () {
                FirebaseFirestore.instance
                    .collection("Houses")
                    .doc(_house.id)
                    .update({
                  "code": Uuid().v1(),
                });
                Navigator.pop(context);
                PopUp.errorPop(
                    "New Code Generated",
                    "QR Code has been Regenerated, please print off the new code",
                    context);
              }, () {
                Navigator.pop(context);
                PopUp.errorPop("Cancelled", "QR code regen cancelled", context);
              }, context);
            }),
            SettingComponent(
                "Change House Name",
                "Change the name of the house. Come up with something creative!",
                "Change", () {
              PopUp.fullScreenPopUp(
                  "New House Name",
                  "The qr code doesn't change if you do this!",
                  "Change", (TextEditingController t) {
                FirebaseFirestore.instance
                    .collection("Houses")
                    .doc(_house.id)
                    .update({
                  "name": t.value.text,
                });
                Navigator.pop(context);
                PopUp.errorPop("House Name Changed",
                    "Your house is now named, ${t.value.text}", context);
              }, (s) {
                return s.isNotEmpty;
              }, context);
            })
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
  bool disposed;

  _MemberViewState(this.houseId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disposed = false;
    FirebaseFirestore.instance
        .collection("Houses")
        .doc(houseId)
        .snapshots()
        .listen((DocumentSnapshot ds) {
      this.house = House.fromMap(ds.data(), ds.id);
      if (!disposed) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            PopUp.fullScreenPopUp(
                "New Member",
                "Add a member to the house! Type in the email below!",
                "Confirm", (TextEditingController t) {
              String email = t.value.text;
              if (house.members.contains(email)) {
                Navigator.pop(context);
                PopUp.errorPop(
                    "Already in the House",
                    "This person has already been added to the house!",
                    context);
                return;
              }
              FirebaseFirestore.instance
                  .collection("People")
                  .where("email", isEqualTo: email)
                  .get()
                  .then((value) {
                if (value.docs.length == 1) {
                  FirebaseFirestore.instance
                      .collection("Houses")
                      .doc(house.id)
                      .update({
                    "members": FieldValue.arrayUnion([email])
                  }).then((value) {
                    Navigator.pop(context);
                    PopUp.errorPop(
                        "Person Added!",
                        "Ask them to open up the app, and your house should be on the list!",
                        context);
                  });
                } else {
                  Navigator.pop(context);
                  PopUp.errorPop(
                      "Email not found!",
                      "Please make sure that they have signed up to knoqr!",
                      context);
                }
              });
            }, (String s) {
              return s.isNotEmpty;
            }, context);
          },
          label: Text(
            "Add",
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white),
          ),
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
                  return PersonCard(house.members[i], () {
                    print("REMOVING ${house.members[i]}");
                    if (house.members[i] == house.owner) {
                      PopUp.errorPop(
                          "Can't remove the owner!",
                          "Can't remove the owner, please choose someone else",
                          c);
                      return;
                    }
                    FirebaseFirestore.instance
                        .collection("Houses")
                        .doc(house.id)
                        .update({
                      "members": FieldValue.arrayRemove([house.members[i]])
                    });
                  });
                },
                itemCount: house != null ? house.members.length : 0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
