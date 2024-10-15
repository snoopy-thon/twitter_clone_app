import 'package:flutter/material.dart';
import 'package:twitter_clone_app/components/my_button.dart';
import 'package:twitter_clone_app/components/my_loading_circle.dart';
import 'package:twitter_clone_app/components/my_text_field.dart';
import 'package:twitter_clone_app/pages/register_page.dart';
import 'package:twitter_clone_app/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;
  LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  void login() async {
    showLoadingCircle(context);
    try {
      await _auth.loginEmailPassword(emailController.text, pwController.text);
      if (mounted) hideLoadingCircle(context);
    } catch (e) {
      if (mounted) hideLoadingCircle(context);
      if (mounted)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Icon(
                Icons.lock_open,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: 'Enter Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: pwController,
                hintText: 'Enter Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MyButton(text: 'Login', onTap: login),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a memeber?',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
