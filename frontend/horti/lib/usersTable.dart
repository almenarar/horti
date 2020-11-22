import 'package:horti/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:horti/schemas.dart';
import 'package:horti/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Users> {
  var _userNameControler = TextEditingController();
  var _userPwdControler = TextEditingController();
  String _userRoleControler = "seller";
  var _userEmailControler = TextEditingController();
  var _userPhoneControler = TextEditingController();

  @override
  void dispose() {
    _userNameControler.dispose();
    _userEmailControler.dispose();
    _userPhoneControler.dispose();
    super.dispose();
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  //int _rowsPerPage = 2;
  int _sortColumnIndex;
  bool _sortAscending = true;

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<User> _filteredNames;
  List<User> _names;

  _MyAppState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredNames = _names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    _items = fetchUsers();
    super.didChangeDependencies();
  }

  Future<List<User>> _items;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    Widget _searchBar = Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 50,
        child: TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Digite um nome...'),
        ));

    void _updateUser(String id) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return Material(
                  child: Center(
                      child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Text(
                          "Atualizar Dados",
                          style: TextStyle(color: Colors.greenAccent),
                          textScaleFactor: 3,
                        )),
                    Container(
                      child: TextField(
                        controller: _userNameControler,
                        decoration: InputDecoration(
                            labelText: 'Nome',
                            contentPadding: EdgeInsets.all(40),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFB3FFBB)))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      width: 400,
                      height: 80,
                    ),
                    Container(
                      child: TextField(
                        controller: _userPwdControler,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            contentPadding: EdgeInsets.all(40),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFB3FFBB)))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      width: 400,
                      height: 80,
                    ),
                    Container(
                      child: DropdownButton<String>(
                        value: _userRoleControler,
                        //icon: Icon(Icons.arrow_downward),
                        //iconSize: 24,
                        isExpanded: true,
                        elevation: 16,
                        style: TextStyle(color: Colors.green),
                        underline: Container(
                          height: 1.5,
                          color: Colors.greenAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _userRoleControler = newValue;
                          });
                        },
                        items: <String>['admin', 'manager', 'seller']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      width: 400,
                      height: 80,
                    ),
                    Container(
                      child: TextField(
                        controller: _userEmailControler,
                        decoration: InputDecoration(
                            labelText: 'E-mail principal',
                            contentPadding: EdgeInsets.all(40),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFB3FFBB)))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      width: 400,
                      height: 80,
                    ),
                    Container(
                      child: TextField(
                        controller: _userPhoneControler,
                        decoration: InputDecoration(
                            labelText: 'Telefone',
                            contentPadding: EdgeInsets.all(40),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFB3FFBB)))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      width: 400,
                      height: 80,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonHeight: 50,
                      buttonMinWidth: 150,
                      overflowButtonSpacing: 30,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Cancelar'),
                          color: Colors.redAccent,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            'Atualizar',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.greenAccent,
                          onPressed: () {
                            updateUser(
                                id,
                                _userNameControler.text,
                                _userPwdControler.text,
                                _userRoleControler,
                                _userEmailControler.text,
                                _userPhoneControler.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                ),
                color: Colors.white,
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 1.2,
              )));
            });
          });
    }

    Widget _datatable(List<User> _items) {
      void _sort<T>(
          Comparable<T> getField(User d), int columnIndex, bool ascending) {
        _items.sort((User a, User b) {
          if (!ascending) {
            final User c = a;
            a = b;
            b = c;
          }
          final Comparable<T> aValue = getField(a);
          final Comparable<T> bValue = getField(b);
          return Comparable.compare(aValue, bValue);
        });
        setState(() {
          _sortColumnIndex = columnIndex;
          _sortAscending = ascending;
        });
      }

      List<Widget> _selectedActions() {
        final _delete = IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() async {
              for (var item in _items
                  ?.where((d) => d?.selected ?? false)
                  ?.toSet()
                  ?.toList()) {
                _items.remove(item);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                var _token = prefs.getString('token');
                var response = await http.delete(
                    'http://localhost:8000/user/${item.id}',
                    headers: {'Authorization': _token});

                if (response.statusCode == 200) {
                  showToast("Usuário deletado.",
                      position: ToastPosition.bottom);
                  setState(() {});
                }
              }
            });
          },
        );

        int len = 0;
        User item;
        for (var user in _items.where((element) => element.selected == true)) {
          ++len;
          item = user;
        }
        if (len == 1) {
          final _edit = IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _userNameControler = TextEditingController(text: item.name);
                  _userPwdControler = TextEditingController(text: "anything");
                  _userRoleControler = item.role;
                  _userEmailControler = TextEditingController(text: item.email);
                  _userPhoneControler = TextEditingController(text: item.phone);
                  _updateUser(item.id);
                });
              });
          return [_edit, _delete];
        }
        return [_delete];
      }

      return NativeDataTable.builder(
        rowsPerPage: _rowsPerPage,
        itemCount: _items?.length ?? 0,
        firstRowIndex: _rowsOffset,
        handleNext: () async {
          setState(() {
            _rowsOffset += _rowsPerPage;
          });
        },
        handlePrevious: () {
          setState(() {
            _rowsOffset -= _rowsPerPage;
          });
        },

        itemBuilder: (int index) {
          final User user = _items[index];
          return DataRow.byIndex(
              index: index,
              selected: user.selected,
              onSelectChanged: (bool value) {
                if (user.selected != value) {
                  setState(() {
                    user.selected = value;
                  });
                }
              },
              cells: <DataCell>[
                DataCell(Text('${user.name}')),
                DataCell(Text('${user.role}')),
                DataCell(Text('${user.email}')),
                DataCell(Text('${user.phone}')),
                DataCell(Text('${user.lastLogin}')),
                DataCell(Text('${user.createdAt}')),
              ]);
        },
        //header: const Text('Data Management'),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onRefresh: () async {
          setState(() {
            didChangeDependencies();
          });

          //return null;
        },
        onRowsPerPageChanged: (int value) {
          setState(() {
            _rowsPerPage = value;
          });
          print("New Rows: $value");
        },
        onSelectAll: (bool value) {
          for (var row in _items) {
            setState(() {
              row.selected = value;
            });
          }
        },
        rowCountApproximate: false,
        actions: <Widget>[_searchBar],
        selectedActions: _selectedActions(),
        columns: <DataColumn>[
          DataColumn(
              label: const Text('Nome'),
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>((User d) => d.name, columnIndex, ascending)),
          DataColumn(label: const Text('Função')),
          DataColumn(
            label: const Text('E-mail'),
          ),
          DataColumn(
            label: const Text('Telefone'),
          ),
          DataColumn(
            label: const Text('Visto por último'),
          ),
          DataColumn(
            label: const Text('Data de Criação'),
          ),
        ],
      );
    }

    return Material(
        child: FutureBuilder(
            future: _items,
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasData) {
                _filteredNames = snapshot.data;
                if ((_searchText.isNotEmpty)) {
                  List<User> tempList = new List();
                  for (int i = 0; i < _filteredNames.length; i++) {
                    if (_filteredNames[i]
                        .name
                        .toLowerCase()
                        .contains(_searchText.toLowerCase())) {
                      tempList.add(_filteredNames[i]);
                    }
                  }
                  _filteredNames = tempList;
                }

                return _datatable(_filteredNames);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }));
  }
}
