import 'package:diinq/Components/Button.dart';
import 'package:diinq/Components/TextBox.dart';
import 'package:diinq/Providers/UserData.dart';
import 'package:diinq/Screens/LoginSignUpScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Components/PopUp.dart';
import 'Providers/Auth.dart';
import 'package:flutter/services.dart';

import 'Screens/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider<UserData>(create: (_) => UserData()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          Color c = new Color(0xff2B6FA7);
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: c,
                scaffoldBackgroundColor: Colors.white,
                dividerColor: Color(0xffF3F3F3),
                fontFamily: 'Poppins',
                textTheme: TextTheme(
                  headline6: TextStyle(
                      color: c, fontSize: 32, fontWeight: FontWeight.bold),
                  caption: TextStyle(
                      color: Color(0xff787878),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  button: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  bodyText1: TextStyle(
                      color: Color(0xff435250),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                )),
            home: Provider.of<Auth>(
                      context,
                    ).currentState !=
                    AuthState.lIn
                ? LoadingScreen()
                : HomePage(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repeatPassword = TextEditingController();
  var signIn = true;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  double height = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: LayoutBuilder(
        builder: (context, bu) {
          return KeyboardAware(builder: (cont, op) {
            if (!op.isKeyboardOpen && height == 0.0) {
              height = bu.maxHeight;
            }
            if (MediaQuery.of(context).size.shortestSide > 600) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: height,
                  // MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.vertical
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _repeatPassword.clear();
                              setState(() {
                                signIn = !signIn;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0))),
                              child: Center(
                                  child: Text(
                                signIn ? "Sign Up" : "Log In",
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontSize: 14),
                              )),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Image.asset(
                          "images/logo/logot.png",
                          width: 180,
                          height: 180,
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextBox(_email, "Email"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextBox(
                                  _password,
                                  "Password",
                                  conceal: true,
                                ),
                              ),
                              IgnorePointer(
                                ignoring: signIn,
                                child: AnimatedOpacity(
                                  opacity: signIn ? 0.0 : 1.0,
                                  duration: Duration(milliseconds: 200),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextBox(
                                        _repeatPassword, "Repeat Password",
                                        conceal: true),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IgnorePointer(
                            ignoring: !signIn,
                            child: GestureDetector(
                              onTap: () {
                                if (_email.value.text.trim().isEmpty) {
                                  PopUp.errorPop(
                                      "Enter a valid Email",
                                      "Please enter a valid email address!",
                                      context);
                                  return;
                                }
                                Auth.getSignInMethods(_email.value.text)
                                    .then((value) {
                                  if (value.length == 0) {
                                    PopUp.errorPop(
                                        "Email address not recognised",
                                        "Please sign up first!",
                                        context);
                                    return;
                                  }
                                  Auth.resetPassword(_email.value.text);
                                  PopUp.errorPop(
                                      "Check Your Email",
                                      "An Email has been sent for you to rest your password!",
                                      context);
                                });
                              },
                              child: AnimatedOpacity(
                                opacity: !signIn ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 200),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).dividerColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text(
                                      "Reset Password",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 30.0),
                                      child: ThicButton("Log In", () async {
                                        //send login req
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .signinUsingEmail(_email.value.text,
                                                _password.value.text)
                                            .then((value) {
                                          print("VALUE: $value");
                                          switch (value) {
                                            case "no user":
                                              PopUp.errorPop(
                                                  "Existential Crisis",
                                                  "You don't seem to exist yet, tap the sign up button in the top right corner!",
                                                  context);
                                              break;
                                            case "wrong":
                                              PopUp.errorPop(
                                                  "Incorrect Password",
                                                  "Well that was wrong!",
                                                  context);
                                              break;
                                          }
                                        });
                                      }),
                                    ),
                                    IgnorePointer(
                                      ignoring: signIn,
                                      child: AnimatedOpacity(
                                        opacity: signIn ? 0.0 : 1.0,
                                        duration: Duration(milliseconds: 200),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 30.0),
                                          child: ThicButton("Sign Up", () {
                                            print("Sign Up");
                                            if (_password.value.text !=
                                                _repeatPassword.value.text) {
                                              PopUp.errorPop(
                                                  "Passwords Don't Match",
                                                  "Make sure the passwords match!",
                                                  context);
                                              return;
                                            }
                                            Provider.of<Auth>(context,
                                                    listen: false)
                                                .registerUsingEmail(
                                                    _email.value.text,
                                                    _password.value.text)
                                                .then((value) {
                                              print("VALUE: $value");
                                              switch (value) {
                                                case "weak":
                                                  PopUp.errorPop(
                                                      "Weak Password",
                                                      "The password is too weak!",
                                                      context);
                                                  break;
                                                case "exists":
                                                  PopUp.errorPop(
                                                      "Existential Crisis",
                                                      "You already exist!",
                                                      context);
                                                  break;
                                              }
                                            });
                                          }),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Container(
                height: height,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _repeatPassword.clear();
                            setState(() {
                              signIn = !signIn;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0))),
                            child: Center(
                                child: Text(
                              signIn ? "Sign Up" : "Log In",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                            )),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Image.asset(
                        "images/logo/logot.png",
                        width: 180,
                        height: 180,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextBox(_email, "Email"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextBox(
                                  _password,
                                  "Password",
                                  conceal: true,
                                ),
                              ),
                              IgnorePointer(
                                ignoring: signIn,
                                child: AnimatedOpacity(
                                  opacity: signIn ? 0.0 : 1.0,
                                  duration: Duration(milliseconds: 200),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextBox(
                                        _repeatPassword, "Repeat Password",
                                        conceal: true),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IgnorePointer(
                          ignoring: !signIn,
                          child: GestureDetector(
                            onTap: () {
                              if (_email.value.text.trim().isEmpty) {
                                PopUp.errorPop(
                                    "Enter a valid Email",
                                    "Please enter a valid email address!",
                                    context);
                                return;
                              }
                              Auth.getSignInMethods(_email.value.text)
                                  .then((value) {
                                if (value.length == 0) {
                                  PopUp.errorPop("Email address not recognised",
                                      "Please sign up first!", context);
                                  return;
                                }
                                Auth.resetPassword(_email.value.text);
                                PopUp.errorPop(
                                    "Check Your Email",
                                    "An Email has been sent for you to rest your password!",
                                    context);
                              });
                            },
                            child: AnimatedOpacity(
                              opacity: !signIn ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 200),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Text(
                                    "Reset Password",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 30.0),
                                    child: ThicButton("Log In", () async {
                                      //send login req
                                      Provider.of<Auth>(context, listen: false)
                                          .signinUsingEmail(_email.value.text,
                                              _password.value.text)
                                          .then((value) {
                                        print("VALUE: $value");
                                        switch (value) {
                                          case "no user":
                                            PopUp.errorPop(
                                                "Existential Crisis",
                                                "You don't seem to exist yet, tap the sign up button in the top right corner!",
                                                context);
                                            break;
                                          case "wrong":
                                            PopUp.errorPop(
                                                "Incorrect Password",
                                                "Well that was wrong!",
                                                context);
                                            break;
                                        }
                                      });
                                    }),
                                  ),
                                  IgnorePointer(
                                    ignoring: signIn,
                                    child: AnimatedOpacity(
                                      opacity: signIn ? 0.0 : 1.0,
                                      duration: Duration(milliseconds: 200),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 30.0),
                                        child: ThicButton("Sign Up", () {
                                          print("Sign Up");
                                          if (_password.value.text !=
                                              _repeatPassword.value.text) {
                                            PopUp.errorPop(
                                                "Passwords Don't Match",
                                                "Make sure the passwords match!",
                                                context);
                                            return;
                                          }
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .registerUsingEmail(
                                                  _email.value.text,
                                                  _password.value.text)
                                              .then((value) {
                                            print("VALUE: $value");
                                            switch (value) {
                                              case "weak":
                                                PopUp.errorPop(
                                                    "Weak Password",
                                                    "The password is too weak!",
                                                    context);
                                                break;
                                              case "exists":
                                                PopUp.errorPop(
                                                    "Existential Crisis",
                                                    "You already exist!",
                                                    context);
                                                break;
                                            }
                                          });
                                        }),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        },
      ),
    ));
  }
}
