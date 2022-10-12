import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/screens/home_screen.dart';
import 'package:firebasetest/screens/signup_screen.dart';
import 'package:firebasetest/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../error_message/show_error_message.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Login Screen',
          ),
        ),
        automaticallyImplyLeading: false,
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
                  width: 200,
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
                    onPressed: signInButtonClick,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
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

  void signUpButtonClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  void signInButtonClick() async {
    setState(() {
      _isLoading = true;
    });
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      User? user = await AuthService()
          .loginUser(_emailController.text, _passwordController.text);
      if (user != null) {
        print(user.uid);
        await SharedPreferencesService.saveBoolToShareedferences(
            'user_logged_in', true);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          ModalRoute.withName('/'),
        );
      } else {
        ShowErrorMessage.showMessage(context, 'Wrong login credential');
      }
    } else {
      ShowErrorMessage.showMessage(context, 'Enter a valid email & password');
    }
    setState(() {
      _isLoading = false;
    });
  }
}
