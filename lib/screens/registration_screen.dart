import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
class RegistrationScreen extends StatefulWidget {
  static String id="register";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email,password;
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email =value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email',),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password',),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  buttonTitle: 'Register',
                  buttonBG: Colors.blueAccent,
                  onPressed: () async{
                    setState(() {
                      showSpinner=true;
                    });
                   try{
                     final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                     if(newUser != null){
                       Navigator.pushNamed(context, ChatScreen.id);
                     }
                     setState(() {
                       showSpinner= false;
                     });
                   }
                   catch(e){print(e);}
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
