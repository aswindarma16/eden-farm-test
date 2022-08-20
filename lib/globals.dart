import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Colors.green;
const Color bottomBarInactiveColor = Colors.black45;

final auth = FirebaseAuth.instance;

UserCredential? user;

CircularProgressIndicator loadingProgressIndicator = CircularProgressIndicator(
  backgroundColor: Colors.green[50],
  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
);

onWillPopExit(BuildContext pageContext, bool availableToPop) {
  return availableToPop ? Future.value(true) : showDialog(
    context: pageContext,
    builder: (context) => AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("Do you want to exit this app?"),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        MaterialButton(
          onPressed: () => exit(0),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}