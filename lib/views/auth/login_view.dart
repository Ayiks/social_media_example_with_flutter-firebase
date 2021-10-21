import 'package:familicious/managers/auth_manager.dart';
import 'package:familicious/views/auth/create_account_view.dart';
import 'package:familicious/views/auth/forgot_password_view.dart';
import 'package:familicious/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9)+\.[a-zA-Z]+");

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  final AuthManager _authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  label: Text('Email',
                      style:
                          Theme.of(context).inputDecorationTheme.labelStyle)),
              validator: (value) {
                if (!emailRegexp.hasMatch(value!)) {
                  return 'Enter is inavlid';
                }
                if (value.isEmpty) {
                  return ' Email is required';
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  label: Text('Password',
                      style:
                          Theme.of(context).inputDecorationTheme.labelStyle)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 8) {
                  return 'password should be not less than 8 characters';
                }
              },
            ),
            const SizedBox(
              height: 35,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordView()));
                },
                child: Text('Forgot Password',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey)),
              ),
            ),
            _authManager.isLoading
                ? Center(child: const CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        bool isSuccessful = await _authManager.loginUser(
                            email: _emailController.text,
                            password: _passwordController.text);
                            setState(() {
                              _isLoading=false;
                            });

                            if (isSuccessful) {
                              Fluttertoast.showToast(
                                msg: 'Welcome back to Famlicious',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                                (route) => false);
                              
                            } else {
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
                        //error
                        Fluttertoast.showToast(
                                msg: 'Email and Password required',
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
                    child: Text('Login',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary)),
                  ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateAccountView()));
                },
                child: Text('Create Account',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey)),
              ),
            )
          ],
        ),
      )),
    );
  }
}
