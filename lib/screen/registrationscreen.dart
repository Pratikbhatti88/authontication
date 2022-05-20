import 'dart:io';

import 'package:authontication/model/users_model.dart';
import 'package:authontication/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();

  final _firstname = TextEditingController();

  final _secondname = TextEditingController();

  final _confirmpassword = TextEditingController();

  final _emailcontroller = TextEditingController();

  final _passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  dynamic userImagefile;

  void signup(String email, String password) async {
    if (userImagefile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please pick in image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } else if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => PostDetailtoFirestore())
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

  void pickedimage(dynamic image) {
    setState(() {
      userImagefile = image;
    });
  }

  PostDetailtoFirestore() async {
    FirebaseFirestore firbasefirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    UserModel userModel = UserModel(
        uid: user!.uid,
        email: user.email,
        firstname: _firstname.text,
        secondname: _secondname.text);

    await firbasefirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.tomap());
    Fluttertoast.showToast(msg: 'Account Sucessfully created');
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final firstnameform = TextFormField(
      controller: _firstname,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        _firstname.text = value!;
      },
      decoration: InputDecoration(
          hintText: 'First Name',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final secondnameform = TextFormField(
      controller: _secondname,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Second Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _secondname.text = value!;
      },
      decoration: InputDecoration(
          hintText: 'Second Name',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final confirmpassword = TextFormField(
      controller: _confirmpassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'confirm password should not be empty';
        }
        if (value != _passwordcontroller.text) {
          return 'Password and confirm password not be match';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _confirmpassword.text = value!;
      },
      decoration: InputDecoration(
          hintText: 'Confirm Password',
          prefixIcon: Icon(Icons.vpn_key),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final emailtextform = TextFormField(
      controller: _emailcontroller,
      onSaved: (value) {
        _emailcontroller.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Email must be required";
        } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(value)) {
          return "email invalid";
        }
      },
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
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.amber,
              )),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/csklogo.png',
                    //   height: 200,
                    //   width: 300,
                    // ),
                    UserPicker(pickedimage),

                    firstnameform,
                    SizedBox(
                      height: 10,
                    ),
                    secondnameform,
                    SizedBox(
                      height: 10,
                    ),
                    emailtextform,
                    SizedBox(
                      height: 10,
                    ),
                    passwordtextform,
                    SizedBox(
                      height: 10,
                    ),
                    confirmpassword,
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        signup(_emailcontroller.text, _passwordcontroller.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 10),
                        child: Text(
                          'Sign Up ',
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
