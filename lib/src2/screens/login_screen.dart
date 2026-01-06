import 'package:flutter/material.dart';

import '../blocs/bloc.dart';
import '../blocs/providers.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: const EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          children: [emailField(bloc), passwordField(bloc), loginButton(bloc)],
        ),
      ),
    );
  }

  Widget emailField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: snapshot.error as String?,
            hintText: 'you@example.com',
            labelText: 'Email address',
          ),
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          decoration: InputDecoration(
            errorText: snapshot.error as String?,
            labelText: 'Password',
            hintText: 'Password',
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: false,
          onChanged: (passwordValue) {
            bloc.changePassword(passwordValue);
          },
        );
      },
    );
  }

  Widget loginButton(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.isLoginValid,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: ElevatedButton(
            onPressed: snapshot.hasData ? bloc.login : null,
            child: Text('login'),
          ),
        );
      },
    );
  }
}
