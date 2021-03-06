import 'dart:io';

import 'package:familicious/managers/auth_manager.dart';
import 'package:familicious/utilities/utilities.dart';
import 'package:familicious/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccountView extends StatefulWidget {
  CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthManager _authManager = AuthManager();

  File? _imageFile;

  final ImagePicker _imagePicker = ImagePicker();

   bool _isLoading = false;

  final emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9)+\.[a-zA-Z]+");

  Future selectImage({ImageSource imageSource = ImageSource.camera}) async {
    XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);
    File? croppedFile = await myImageCropper(selectedFile!.path);
    

    setState(() {
      _imageFile = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // CircleAvatar(
              //   radius: 65,
              //   backgroundImage: (_imageFile == null
              //       ? const AssetImage('assets/memoji.png')
              //       : FileImage(_imageFile!)) as ImageProvider,
              // ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: _imageFile == null
                      ? Image.asset(
                          'assets/memoji.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          _imageFile!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectImage(
                                          imageSource: ImageSource.camera);
                                    },
                                    icon: Icon(UniconsLine.camera),
                                    label: Text('select From camera')),
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      selectImage(
                                          imageSource: ImageSource.gallery);
                                    },
                                    icon: Icon(UniconsLine.picture),
                                    label: Text('select From Galerry')),
                              ],
                            ),
                          );
                        });
                  },
                  icon: Icon(UniconsLine.camera),
                  label: Text('Select Profile Picture')),
              const SizedBox(
                height: 35,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.caption,
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    label: Text('Full Name',
                        style:
                            Theme.of(context).inputDecorationTheme.labelStyle)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your fullname';
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.caption,
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
                style: Theme.of(context).textTheme.caption,
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
                height: 25,
              ),
              _isLoading
                  ? Center(child: const CircularProgressIndicator.adaptive())
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          //true
                          setState(() {
                            _isLoading = true;
                          });
                          bool isCreated = await _authManager.createNewUser(
                              name: name,
                              email: email,
                              password: password,
                              imageFile: _imageFile!);
                          //false isloading
                          if (isCreated) {
                            setState(() {
                            _isLoading = false;
                          });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                                (route) => false);
                            Fluttertoast.showToast(
                                msg: "Welcome!, $name",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
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
                          //validation failed
                          Fluttertoast.showToast(
                              msg: "Please check Input field(s)",
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
                      child: Text('Create Account',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary)),)
            ],
          ),
        ),
      ),
    );
  }
}
