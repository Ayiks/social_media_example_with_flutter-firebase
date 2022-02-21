import 'package:familicious/managers/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  final emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9)+\.[a-zA-Z]+");

  bool isLoading = false;
  final AuthManager _authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const FlutterLogo(
            size: 130,
          ),
          const SizedBox(
            height: 35,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.caption,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                label: Text('Email',
                    style: Theme.of(context).inputDecorationTheme.labelStyle),
                hintText: 'please enter your email'),
            validator: (value) {
              if (!emailRegexp.hasMatch(value!)) {
                return 'Email is inavlid';
              }
              if (value.isEmpty) {
                return ' Email is required';
              }
            },
          ),
          const SizedBox(
            height: 25,
          ),
          isLoading
              ? Center(child: const CircularProgressIndicator.adaptive())
              : TextButton(
                  onPressed: () async {
                    if (_emailController.text.isNotEmpty &&
                        emailRegexp.hasMatch(_emailController.text)) {
                      setState(() {
                        isLoading = true;
                      });
                      bool isSent = await _authManager
                          .sendResetLink(_emailController.text);
                      if (isSent) {
                        //success
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Please check your email for the link",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } else {
                        //error
                        Fluttertoast.showToast(
                            msg: _authManager.message,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Email is required',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .buttonTheme
                          .colorScheme!
                          .background),
                  child: Text('Reset Password',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary)),
                )
        ],
      )),
    );
  }
}
