import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget {
  Provider({super.key, required super.child});

  final bloc = Bloc();

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static Bloc of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<Provider>()!.bloc;
  }
}
