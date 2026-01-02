import 'package:flutter/material.dart';
import '../mixins/validator_mixin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with ValidationMixin {
  // Instance fields
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailField(),
            passwordField(),
            const SizedBox(height: 25.0),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email address',
        hintText: 'you@example.com',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (newValue) {
        email = newValue ?? '';
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.text,
      // obscureText: true,
      obscuringCharacter: '*',
      validator: validatePassword,
      onSaved: (newValue) {
        password = newValue ?? '';
      },
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        final isFormValid = formKey.currentState?.validate() ?? false;

        if (isFormValid) {
          formKey.currentState?.save();
          // Consume the values here on
          debugPrint('Email: $email, Password: $password');
        }
      },
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
      child: Text('Login', style: TextStyle(color: Colors.white)),
    );
  }
}
