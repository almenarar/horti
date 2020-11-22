import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameControler = TextEditingController();
  final _passwordControler = TextEditingController();

  @override
  void dispose() {
    _usernameControler.dispose();
    _passwordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _info = Container(
      child: Image.asset(
        'assets/images/logo.jpeg',
      ),
      width: 400,
      height: 400,
      //padding: const EdgeInsets.only(top: 25),
    );

    final Widget _username = Container(
      child: TextField(
        controller: _usernameControler,
        decoration: InputDecoration(
            labelText: 'usuário',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      width: 400,
      height: 80,
    );

    final Widget _password = Container(
      child: TextField(
        controller: _passwordControler,
        decoration: InputDecoration(
            labelText: 'senha',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
        obscureText: true,
      ),
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: 400,
      height: 80,
    );

    final RaisedButton _loginButton = RaisedButton(
        child: Text('Login'),
        onPressed: () async {
          var _response =
              await login(_usernameControler.text, _passwordControler.text);
          if (_response != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', _response);
            var _scopes = await http.post('http://localhost:8000/me',
                headers: {'Authorization': _response});
            await prefs.setString('scope', _scopes.body);
            //var foo = prefs.getString('token');
            Navigator.pushNamed(context, '/home');
          } else {
            showToast("Login Incorreto", position: ToastPosition.bottom);
          }
        });

    final Widget _primary = Material(
      child: Column(
        children: <Widget>[
          _info,
          _username,
          _password,
          _loginButton,
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      color: Colors.white,
    );

    return _primary;
  }
}

Future<String> login(String name, String pwd) async {
  var requestBody = '{"Name": "$name", "Password": "$pwd"}';
  final response =
      await http.post('http://localhost:8000/auth', body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}
