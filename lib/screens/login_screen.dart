import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/paddingcomponents.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;
  String errorMessage = '';
  bool _spinner = false;
  String firebaseErrorMessage =
      '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _spinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 200.0,
                  child:
                      Hero(tag: 'logo', child: Image.asset('images/logo.png')),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      helperText: '        Password should be of atleast 6 characters.',
                      hintText: 'Enter Your Password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                PaddingElement(
                    colorType: Colors.lightBlueAccent,
                    textElement: 'Login',
                    onFunction: () async {
                      setState(() {
                        _spinner = true;
                      });

                      try {
                        UserCredential existingUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (existingUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            _spinner = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          _spinner = false;
                        });
                        if (e.toString() == firebaseErrorMessage) {
                          setState(() {
                            errorMessage =
                                "Your all requests are blocked due to unusal activity ";
                          });
                        } else {
                          setState(() {
                            errorMessage = 'Your account does not exist';
                          });
                        }
                      }
                    }),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                    child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red[300]),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
