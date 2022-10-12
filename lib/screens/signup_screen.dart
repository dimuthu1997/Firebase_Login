import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../error_message/show_error_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign Up Screen')),
      ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.home_repair_service,
                      color: Colors.blue,
                      size: 100,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'Email'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    onChanged: (value) {
                      //print("output of password : $value");
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'Password'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUpButtonClick,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
          ),
          Visibility(
            visible: _isLoading,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.1),
              child: Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void signUpButtonClick() async {
    setState(() {
      _isLoading = true;
    });
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      User? user = await AuthService()
          .registerUser(_emailController.text, _passwordController.text);
      if (user != null) {
        print(user.uid);
      }
    } else {
      ShowErrorMessage.showMessage(context, 'Enter a valid email & password');
    }
    setState(() {
      _isLoading = false;
    });
  }
}
