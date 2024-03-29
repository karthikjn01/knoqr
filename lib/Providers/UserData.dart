import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserData extends ChangeNotifier {
  int state = 0; //0 = loading, 1 = empty, 2 = !empty
  List<House> houses = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String email = "";

  void init(String email) {
    state = 0;
    this.email = email;
    // notifyListeners();

    _db
        .collection("Houses")
        .where("members", arrayContains: email)
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((element) {
        if (element.data() != null && element.data().length > 0) {
          houses.add(House.fromMap(element.data(), element.id));
        }
      });
      if (houses.length > 0) {
        state = 2;
      } else {
        state = 1;
      }
      notifyListeners();
    });
  }

  void create(String name) {
    _db.collection("Houses").add({
      "members": [email],
      "owner": email,
      "name": name,
      "code": Uuid().v4(),
      "messages": [],
    }).then((value) {
      refresh();
    });
  }

  void refresh() {
    state = 0;
    notifyListeners();
    houses.clear();
    _db
        .collection("Houses")
        .where("members", arrayContains: email)
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((element) {
        if (element.data() != null && element.data().length > 0) {
          houses.add(House.fromMap(element.data(), element.id));
          print("ELEMENT ID : " + element.id);
          FirebaseMessaging().subscribeToTopic(element.id);
        }
      });

      if (houses.length > 0) {
        state = 2;
      } else {
        state = 1;
      }
      notifyListeners();
    });
  }

  void clear() {
    state = 0;
    houses.clear();
    email = "";
  }
}

class House {
  String name;
  String id;
  String code;
  String fcm;
  List<String> members;
  String owner;
  List<Message> messages;

  static House fromMap(Map<String, dynamic> data, String id) {
    House h = House();
    h.members = data["members"]
        .map((s) => s as String)
        .toList()
        .cast<String>()
        .toList();
    h.owner = data["owner"];
    h.name = data["name"];
    h.messages = [];
    h.messages = data["messages"]
        .map((s) => Message(
            s["message"], DateTime.fromMillisecondsSinceEpoch(s["time"])))
        .toList()
        .cast<Message>()
        .toList();
    h.code = data["code"];
    print('MESSAGES: ${h.messages}');

    h.id = id;
    return h;
  }

  Future<House> update() async {
    DocumentSnapshot sc = await FirebaseFirestore.instance
        .collection("Houses")
        .doc(this.id)
        .get();
    return fromMap(sc.data(), sc.id);
  }
}

class Message {
  String message;
  DateTime dateTime;

  Message(this.message, this.dateTime);

  String getTime() {
    return DateFormat("HH:mm dd-MM-yy").format(dateTime.toUtc());
  }

  String getMessage() {
    if (message == "<DEFAULT RING>") {
      return "Someone rang at the door";
    }
    return "$message";
  }
}
