import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'package:social_media_app/screens/sign_in.dart';

import '../bloc/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  static const id = "sign_up_screen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    context
        .read<AuthCubit>()
        .signUp(email: _email, username: _username, password: _password);
    Navigator.of(context).pushReplacementNamed(PostScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (prevState, currentState) {
        if (currentState is AuthSignedUp) {
          //Navigator.of(context).pushReplacementNamed(PostScreen.id);
        }
        if (currentState is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(currentState.message)));
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Social Media App",
                      style: Theme.of(context).textTheme.headline3,
                    ),

                    ////////////////////////////////////////////e-mail
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: "Enter your email"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_usernameFocusNode);
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),
                    ),
                    //////////////////////////////////////////
                    const SizedBox(height: 15),
                    ////////////////////////////////////////////user name
                    TextFormField(
                      focusNode: _usernameFocusNode,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: "Enter your username"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (value) {
                        _username = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your username";
                        }
                        return null;
                      },
                    ),
                    //////////////////////////////////////////
                    const SizedBox(height: 15),
                    ////////////////////////////////////////////password
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: "Enter your password"),
                      obscureText: true,
                      onFieldSubmitted: (_) {
                        _submit(context);
                      },
                      onSaved: (value) {
                        _password = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 5) {
                          return "Please enter longer password";
                        }
                        return null;
                      },
                    ),
                    //////////////////////////////////////////

                    const SizedBox(height: 15),
                    TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text("Sign Up")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.id);
                        },
                        child: const Text("Sign In instead"))
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
