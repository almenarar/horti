import 'package:horti/forms.dart';
import 'package:horti/login.dart';
import 'package:horti/home.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() => runApp(Horti());

class Horti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Phoenix(
        child: OKToast(
            child: MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/userform': (context) => UserForm(),
        '/productform': (context) => ProductForm(),
        '/salesform': (context) => SalesForm(),
      },
    )));
  }
}
