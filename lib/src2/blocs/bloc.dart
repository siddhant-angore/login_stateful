import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../mixins/validators_mixin.dart';

/// Note: `with` modifies the base class
class Bloc with ValidatorsMixin {
  // Instance fields
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // Add data to `stream` with `transform`
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get isLoginValid =>
      Rx.combineLatest2(email, password, (emailValue, passwordValue) {
        return true;
      });

  // Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  void login() {
    print(
      'Emai: ${_emailController.valueOrNull}, Password: ${_passwordController.valueOrNull}',
    );
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
