import 'package:authontication/screen/registrationscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final _emailcontroller = TextEditingController();

  final _passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void loginfunction(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) {
        Fluttertoast.showToast(msg: 'Login Successfully');

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailtextform = TextFormField(
      controller: _emailcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email must be required";
        } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(value)) {
          return "email invalid";
        }
      },
      onSaved: (value) {
        _emailcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final passwordtextform = TextFormField(
      controller: _passwordcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password must be required";
        } else if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          return " Enter strong password Ex:Abc@0123";
        }
      },
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        _passwordcontroller.text = value!;
      },
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(Icons.vpn_key),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    return Scaffold(
        body: Container(
      child: Form(
        //autovalidateMode: true,
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/csklogo.png',
                  height: 300,
                  width: 300,
                ),
                emailtextform,
                SizedBox(
                  height: 20,
                ),
                passwordtextform,
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () => loginfunction(
                      _emailcontroller.text, _passwordcontroller.text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 170, vertical: 5),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont have an account?'),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistrationScreen())),
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
