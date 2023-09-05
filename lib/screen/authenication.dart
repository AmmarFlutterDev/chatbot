// ignore_for_file: unused_import, unused_field, unused_local_variable

import 'dart:io';

import 'package:chat_app/widgets/usr_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//  cloud_firestore => to send or get data from firebasae
class AuthenciationScreem extends StatefulWidget {
  const AuthenciationScreem({super.key});

  @override
  State<AuthenciationScreem> createState() {
    return _AuthenciationScreemState();
  }
}

class _AuthenciationScreemState extends State<AuthenciationScreem> {
  final _form = GlobalKey<FormState>();
  bool islogin = true;
  var email = '';
  var passwoord = '';
  File? _selectedimage;
  var isauthenticating = false;
  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || !islogin && _selectedimage == null) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        isauthenticating = true;
      });
      if (islogin) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: passwoord);
      } else {
        var userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: passwoord);

        // ignore: prefer_typing_uninitialized_variables

        final storageref = FirebaseStorage.instance
            .ref()
            .child('User_images')
            .child('${userCredentials.user!.uid}.png');
        storageref.putFile(_selectedimage!);
        storageref.getDownloadURL();
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email alrady in use') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authencation failed')));
    }
    setState(() {
      isauthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: const Image(image: AssetImage('assets/a.png')),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            islogin == false
                                ? Userimagepicker(
                                    onPickedImage: (pickedImage) =>
                                        {_selectedimage = pickedImage},
                                  )
                                : const SizedBox(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'plz entere the correct email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value) {
                                email = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password ',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Paswword must be greater the 5 charcters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                passwoord = value!;
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              isauthenticating == true
                  ? const CircularProgressIndicator()
                  : Container(
                      width: 90,
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: _submit,
                        child: Text(
                          islogin == true ? 'Log in' : 'Sign up',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 15,
              ),
              if (isauthenticating == false)
                Container(
                  width: 200,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(18)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          islogin = !islogin;
                        });
                      },
                      child: Text(
                        islogin == true
                            ? 'create an account'
                            : 'I have alrady an account',
                        style: const TextStyle(color: Colors.white),
                      )),
                )
            ],
          ),
        ),
      ),
    );
  }
}
