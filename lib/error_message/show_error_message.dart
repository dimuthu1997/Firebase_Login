import 'package:flutter/material.dart';

class ShowErrorMessage {
  static void showMessage(BuildContext context, String message) {
    TextButton okButton = TextButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        });
    AlertDialog errorMessageAlert = AlertDialog(
      title: Text("Error"),
      content: Container(child: Text(message)),
      actions: [okButton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return errorMessageAlert;
        });
  }
}
