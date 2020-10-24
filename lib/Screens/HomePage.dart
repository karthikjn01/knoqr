import 'package:diinq/Components/Button.dart';
import 'package:diinq/Components/HouseCard.dart';
import 'package:diinq/Components/PopUp.dart';
import 'package:diinq/Providers/Auth.dart';
import 'package:diinq/Providers/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'HomeView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.email = Provider.of<Auth>(context, listen: false).user.email;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserData>(
        builder: (c, ud, child) {
          print(ud.state);
          if (ud.email.isEmpty) {
            ud.init(email);
          }
          if (ud.state == 0) {
            return Scaffold();
          }
          if (ud.houses.length == 0) {
            return Scaffold(
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Image.asset(
                          "images/logo/logo_o.png",
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('TRYING TO LOGOUT!');
                          Provider.of<Auth>(context, listen: false)
                              .signOut(context);
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          margin: EdgeInsets.all(20.0),
                          child: Icon(Icons.person_remove)
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        "Whoa, you don't have a house yet, do you want to create one?",
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child: ThicButton("Create House", () {
                      PopUp.fullScreenPopUp(
                          "House Name",
                          "Give your homely home a name!",
                          "Confirm", (TextEditingController t) {
                        ud.create(t.value.text);
                        Navigator.pop(context);
                      }, (s) {
                        if (s.trim().isNotEmpty) {
                          return true;
                        } else {
                          PopUp.errorPop("Your house needs a name!",
                              "Give your house a name!", context);
                          return false;
                        }
                      }, context);
                    }),
                  )
                ],
              ),
            );
          }
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Image.asset(
                      "images/logo/logo_o.png",
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('TRYING TO LOGOUT!');
                      Provider.of<Auth>(context, listen: false)
                          .signOut(context);
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      margin: EdgeInsets.all(20.0),
                      child: Icon(Icons.person_remove, color: Theme.of(context).primaryColor,),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () {
                    ud.refresh();
                    return;
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (c, i) {
                      return HouseCard(ud.houses[i], () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => HomeView(ud.houses[i])));
                      });
                    },
                    itemCount: ud.houses.length,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: ThicButton("Create House", () {
                  PopUp.fullScreenPopUp(
                      "House Name", "Give your homely home a name!", "Confirm",
                      (TextEditingController t) {
                    ud.create(t.value.text);
                    Navigator.pop(context);
                  }, (s) {
                    if (s.trim().isNotEmpty) {
                      return true;
                    } else {
                      PopUp.errorPop("Your house needs a name!",
                          "Give your house a name!", context);
                      return false;
                    }
                  }, context);
                }),
              ),
            ],
          ));
        },
      ),
    );
  }
}
