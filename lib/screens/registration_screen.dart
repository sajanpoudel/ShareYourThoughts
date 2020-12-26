import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/paddingcomponents.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegisterScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String errorMessage = '';
  bool _spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _spinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
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
                        hintText: 'Enter Your Password',
                        helperText: '        Password should be of atleast 6 characters.'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  PaddingElement(
                    colorType: Colors.blueAccent,
                    textElement: 'Register',
                    onFunction: () async {
                      try {
                        setState(() {
                          _spinner = true;
                        });
                        UserCredential newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            _spinner = true;
                          });
                        }
                        // print(newUser);
                      } catch (e) {
                        _spinner = false;
                        print(e);
                        if(password.length<=6){
                          setState(() {
                          errorMessage = 'Password should be atleast 6 characters long.';
                        });
                        }
                        else{
setState(() {
                          errorMessage = 'Account already in use';
                        });
                        }
                        
                      }

                      //  print(email);
                      //  print(password);
                    },
                  ),
                  SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red[300],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
