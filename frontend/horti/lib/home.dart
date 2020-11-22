import 'package:flutter/material.dart';
import 'package:horti/usersTable.dart';
import 'package:horti/salesTable.dart';
import 'package:horti/productsTable.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String> futureScopes;
  Future<String> futureUser;

  @override
  void initState() {
    super.initState();
    futureScopes = _getScopes();
    futureUser = _getUser();
  }

  Future<String> _getScopes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _scope = prefs.getString('scope').split(":")[1];
    return _scope;
  }

  Future<String> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _user = prefs.getString('scope').split(":")[0];
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    final Widget _welcome = Container(
      child: FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: Text(
              "Bem vindo, ${snapshot.data}",
              textScaleFactor: 2.5,
              style: TextStyle(color: Colors.greenAccent, fontFamily: 'custom'),
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.height / 7,
    );

    List<Widget> _filltabs(scope) {
      var _buttonlist = <Widget>[];
      _buttonlist.add(Tab(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Produtos",
            textScaleFactor: 1.5,
          ),
        ),
      ));
      _buttonlist.add(Tab(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Vendas",
            textScaleFactor: 1.5,
          ),
        ),
      ));

      int level = 0;
      if (scope == "manager") {
        ++level;
      }
      if (scope == "admin") {
        level += 2;
      }

      if (level > 0) {
        if (level > 1) {
          _buttonlist.add(Tab(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Usuários",
                textScaleFactor: 1.5,
              ),
            ),
          ));
        }
      }

      return _buttonlist;
    }

    List<Widget> _filltabview(scope) {
      var _buttonlist = <Widget>[];
      _buttonlist.add(Products());
      _buttonlist.add(SalesTable());

      int level = 0;
      if (scope == "manager") {
        ++level;
      }
      if (scope == "admin") {
        level += 2;
      }

      if (level > 0) {
        if (level > 1) {
          _buttonlist.add(Users());
        }
      }

      return _buttonlist;
    }

    int _tabslen(scope) {
      int level = 0;
      if (scope == "manager") {
        ++level;
      }
      if (scope == "admin") {
        level += 2;
      }

      if (level > 0) {
        if (level > 1) {
          return 3;
        }
      }

      return 2;
    }

    final Widget _painel = FutureBuilder(
        future: futureScopes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: Container(
                    child: DefaultTabController(
              length: _tabslen(snapshot.data),
              child: Column(
                children: [
                  _welcome,
                  Container(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                      ),
                      height: MediaQuery.of(context).size.height / 13,
                      child: TabBar(
                          labelColor: Colors.greenAccent,
                          unselectedLabelColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.white),
                          tabs: _filltabs(snapshot.data))),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: 15),
                        height: 400,
                        child:
                            TabBarView(children: _filltabview(snapshot.data))),
                  )
                ],
              ),
            )));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });

    final Widget _menuBar = Container(
      child: FutureBuilder(
          future: futureScopes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Actions(scopes: snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 1)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width / 4,
    );

    final Widget _primary = Material(
      child: Row(
        children: <Widget>[
          _menuBar,
          _painel,
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      color: Colors.white,
    );

    return _primary;
  }
}

class Actions extends StatefulWidget {
  const Actions({
    Key key,
    @required this.scopes,
  });

  final String scopes;

  @override
  _ActionsState createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  var _fillColors = <Color>[
    Color(0xFFB3FFBB),
    Color(0xFFB3FFBB),
    Color(0xFFB3FFBB),
    Color(0xFFB3FFBB),
    Colors.redAccent
  ];
  @override
  Widget build(BuildContext context) {
    final Widget _info = Container(
      child: Image.asset(
        'assets/images/logo.jpeg',
      ),
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 5,
      padding: const EdgeInsets.only(bottom: 10),
    );

    Widget _createOption(
        Icon icon, String text, Color color, int index, void Function() func) {
      return InkWell(
        child: AnimatedContainer(
          child: Row(
            children: [icon, Text(text)],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: color, width: 3),
            color: _fillColors[index],
          ),
          //margin: const EdgeInsets.symmetric(vertical: 20),
          height: 50,
          width: MediaQuery.of(context).size.height / 5,
          duration: Duration(milliseconds: 450),
          curve: Curves.fastOutSlowIn,
        ),
        onTap: func,
        onHover: (value) {
          if (value) {
            setState(() {
              _fillColors[index] = Colors.white;
            });
          } else {
            setState(() {
              _fillColors[index] = color;
            });
          }
        },
      );
    }

    List<Widget> _fillactions(scope) {
      var _buttonlist = <Widget>[];
      _buttonlist.add(_info);
      _buttonlist.add(SizedBox(
        height: 35,
      ));

      int level = 0;
      if (scope == "manager") {
        ++level;
      }
      if (scope == "admin") {
        level += 2;
      }

      if (level > 0) {
        if (level > 1) {
          _buttonlist.add(_createOption(
              Icon(Icons.person),
              "Criar usuário",
              Color(0xFFB3FFBB),
              0,
              () => Navigator.pushNamed(context, '/userform')));
          _buttonlist.add(SizedBox(
            height: 35,
          ));
        }
        _buttonlist.add(_createOption(
            Icon(Icons.add),
            "Novo Produto",
            Color(0xFFB3FFBB),
            1,
            () => Navigator.pushNamed(context, '/productform')));
        _buttonlist.add(SizedBox(
          height: 35,
        ));
      }

      _buttonlist.add(_createOption(
          Icon(Icons.monetization_on),
          "Cadastrar Venda",
          Color(0xFFB3FFBB),
          3,
          () => Navigator.pushNamed(context, '/salesform')));
      _buttonlist.add(SizedBox(
        height: 35,
      ));
      _buttonlist.add(_createOption(Icon(Icons.logout), "Logout",
          Colors.redAccent, 4, () => {Phoenix.rebirth(context)}));
      return _buttonlist;
    }

    return Column(
      children: _fillactions(widget.scopes),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
