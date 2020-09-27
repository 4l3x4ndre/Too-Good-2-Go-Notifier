import 'package:flutter/material.dart';

import 'package:tgtg_tracker/pages/timer_page.dart';
import 'package:tgtg_tracker/watcher/api.dart';
import 'package:tgtg_tracker/watcher/config.dart';
import '../constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // style wasn't used that much as it should
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

  final Config config = Config();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = '';

  @override
  void initState() {
    super.initState();
    errorText = '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  void updateErrorText(String msg) {
    setState(() {
      errorText = msg;
    });
  }

  // Get textfields value
  void setIdentifiers() async {
    updateErrorText('');
    if (emailController != null &&
        emailController.text != null &&
        emailController.text != '') {
      config.setConfig("email", emailController.text);
    } else if (emailController.text == '') {
      updateErrorText('Please fill in your email address.');
    } else {
      updateErrorText(
          'An error occured with your email. \nPlease verify and try again.');
    }

    if (passwordController != null &&
        passwordController.text != null &&
        passwordController.text != '') {
      config.setConfig("password", passwordController.text);
    } else if (passwordController.text == '') {
      updateErrorText('Please fill in your password.');
    } else {
      updateErrorText(
          'An error occured with your password. \nPlease verify and try again.');
    }
    verifyAccountInformation(emailController.text, passwordController.text);
  }

  // Check if account's information is valid
  void verifyAccountInformation(login, password) async {
    updateErrorText('Checking...');
    bool success = await Api().login();
    updateErrorText('Result: ' + success.toString());
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TimerPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      updateErrorText('Incorrect account identifiers.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: emailController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: blackColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setIdentifiers();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style:
                style.copyWith(color: lightColor, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        backgroundColor: mediumColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -MediaQuery.of(context).size.width * .75,
                right: -MediaQuery.of(context).size.width / 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2,
                  height: MediaQuery.of(context).size.width * 2,
                  decoration: new BoxDecoration(
                    color: darkColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 45.0),
                        SizedBox(
                          height: 155.0,
                          child: Image.asset(
                            "assets/images/toogoodtogologo.png",
                            height: MediaQuery.of(context).size.height / 7,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text("Use your Too Good To Go identifiers",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: lightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                        SizedBox(height: 45.0),
                        emailField,
                        SizedBox(height: 25.0),
                        passwordField,
                        SizedBox(
                          height: 35.0,
                        ),
                        loginButon,
                        SizedBox(
                          height: 35.0,
                        ),
                        Text('$errorText',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: errorColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
