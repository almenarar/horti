import 'package:flutter/material.dart';
import 'package:horti/database.dart';
import 'package:horti/schemas.dart';
import 'package:intl/intl.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
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

  @override
  Widget build(BuildContext context) {
    final Widget _primary = Material(
        child: Center(
            child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                "Novo Usuário",
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
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                  _userPhoneControler.clear();
                  _userNameControler.clear();
                  _userEmailControler.clear();
                  _userPwdControler.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Criar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.greenAccent,
                onPressed: () {
                  createUser(
                      _userNameControler.text,
                      _userPwdControler.text,
                      _userRoleControler,
                      _userEmailControler.text,
                      _userPhoneControler.text);
                  _userPhoneControler.clear();
                  _userNameControler.clear();
                  _userEmailControler.clear();
                  _userPwdControler.clear();
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
    return _primary;
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  var _productNameControler = TextEditingController();
  var _productPriceControler = TextEditingController();
  var _productExpirateControler = TextEditingController();
  var _productManufacturerControler = TextEditingController();

  @override
  void dispose() {
    _productNameControler.dispose();
    _productPriceControler.dispose();
    _productExpirateControler.dispose();
    _productManufacturerControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _primary = Material(
        child: Center(
            child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                "Novo Produto",
                style: TextStyle(color: Colors.greenAccent),
                textScaleFactor: 3,
              )),
          Container(
            child: TextField(
              controller: _productNameControler,
              decoration: InputDecoration(
                  labelText: 'Nome',
                  contentPadding: EdgeInsets.all(40),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            width: 400,
            height: 80,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 100,
                    height: 80,
                    child: TextField(
                      controller: _productPriceControler,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Preço',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFFB3FFBB)))),
                    )),
                Container(
                    width: 150,
                    height: 80,
                    child: TextField(
                      controller: _productExpirateControler,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Validade Em Dias',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFFB3FFBB)))),
                    )),
              ],
            ),
            //padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            width: 400,
            height: 80,
          ),
          Container(
            child: TextField(
              controller: _productManufacturerControler,
              decoration: InputDecoration(
                  labelText: 'Fornecedor',
                  contentPadding: EdgeInsets.all(40),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                  _productNameControler.clear();
                  _productPriceControler.clear();
                  _productExpirateControler.clear();
                  _productManufacturerControler.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Criar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.greenAccent,
                onPressed: () {
                  createProduct(
                      _productNameControler.text,
                      double.tryParse(_productPriceControler.text),
                      _productManufacturerControler.text,
                      int.tryParse(_productExpirateControler.text));
                  _productExpirateControler.clear();
                  _productNameControler.clear();
                  _productPriceControler.clear();
                  _productManufacturerControler.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 1.5,
    )));
    return _primary;
  }
}

class BatchForm extends StatefulWidget {
  const BatchForm({
    Key key,
    @required this.productID,
  });

  final String productID;

  @override
  _BatchFormState createState() => _BatchFormState();
}

class _BatchFormState extends State<BatchForm> {
  var _batchTotalAmountControler = TextEditingController();

  @override
  void dispose() {
    _batchTotalAmountControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _primary = Material(
        child: Center(
            child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                "Adicionar Lote",
                style: TextStyle(color: Colors.greenAccent),
                textScaleFactor: 3,
              )),
          Container(
            child: TextField(
              controller: _batchTotalAmountControler,
              decoration: InputDecoration(
                  labelText: 'Quantidade de Itens',
                  contentPadding: EdgeInsets.all(40),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                  _batchTotalAmountControler.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Criar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.greenAccent,
                onPressed: () {
                  createBatch(widget.productID,
                      int.tryParse(_batchTotalAmountControler.text));
                  _batchTotalAmountControler.clear();
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
    return _primary;
  }
}

class BatchList extends StatefulWidget {
  const BatchList({
    Key key,
    @required this.productID,
  });

  final String productID;

  @override
  _BatchListState createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
  @override
  void didChangeDependencies() {
    _product = fetchProductbyID(widget.productID);
    super.didChangeDependencies();
  }

  Future<Product> _product;
  final DateFormat formatter = DateFormat.yMd().add_jm();

  List<DataRow> _datarow(List<Batch> batches) {
    List<DataRow> row = [];
    for (var i = 0; i < batches.length; i++) {
      row.add(DataRow(cells: <DataCell>[
        DataCell(Text(batches[i].id)),
        DataCell(Text(batches[i].finalAmount.toString())),
        DataCell(Text(
            formatter.format(DateTime.parse(batches[i].createdAt).toLocal())))
      ]));
    }
    return row;
  }

  @override
  Widget build(BuildContext context) {
    final Widget _primary = Material(
        child: FutureBuilder(
            future: _product,
            builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Text(
                            "Lotes de ${snapshot.data.name}",
                            style: TextStyle(color: Colors.greenAccent),
                            textScaleFactor: 3,
                          )),
                      DataTable(columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Quantidade Atual',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Data de Criação',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ], rows: _datarow(snapshot.data.batches)),
                      Container(
                          child: FlatButton(
                        child: Text('Voltar'),
                        color: Colors.greenAccent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        //padding: EdgeInsets.only(top: 30),
                      )),
                    ],
                  ),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 1.2,
                ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }));
    return _primary;
  }
}

class ExpList extends StatefulWidget {
  @override
  _ExpListState createState() => _ExpListState();
}

class _ExpListState extends State<ExpList> {
  @override
  void didChangeDependencies() {
    _batchesAndProducts = fetchBatchesAndProducts();
    super.didChangeDependencies();
  }

  Future<List<dynamic>> _batchesAndProducts;

  List<DataRow> _datarow(List<dynamic> items) {
    List<DataRow> row = [];
    for (var i = 0; i < items[0].length; i++) {
      for (var j = 0; j < items[1].length; j++) {
        if (items[0][i].productID == items[1][j].id) {
          Duration duration = DateTime.parse(items[0][i].createdAt)
              .add(new Duration(days: items[1][j].daysToExpirate))
              .difference(DateTime.now());
          String sDuration = "${duration.inDays}";
          var dur = int.parse(sDuration);
          if (dur > 3) {
            break;
          }
          row.add(DataRow(cells: <DataCell>[
            DataCell(Text(items[1][j].name)),
            DataCell(Text(items[0][i].id)),
            DataCell(Text(items[0][i].finalAmount.toString())),
            DataCell(Text((sDuration)))
          ]));
        }
      }
    }
    return row;
  }

  @override
  Widget build(BuildContext context) {
    final Widget _primary = Material(
        child: FutureBuilder(
            future: _batchesAndProducts,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Text(
                            "Lotes Próximos de Expirar",
                            style: TextStyle(color: Colors.greenAccent),
                            textScaleFactor: 3,
                          )),
                      DataTable(columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Produto',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Lote',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Itens',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Dias até expirar',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ], rows: _datarow(snapshot.data)),
                      Container(
                          child: FlatButton(
                        child: Text('Voltar'),
                        color: Colors.greenAccent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        //padding: EdgeInsets.only(top: 30),
                      )),
                    ],
                  ),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 1.2,
                ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }));
    return _primary;
  }
}

class SalesForm extends StatefulWidget {
  @override
  _SalesFormState createState() => _SalesFormState();
}

class _SalesFormState extends State<SalesForm> {
  int _itemCount = 1;
  var _paynmentControler = TextEditingController();
  List<List<String>> _productControler = [
    ["-"]
  ];
  List<List<String>> _batchControler = [
    ["-"],
    ["-"],
    ["-"],
    ["-"],
    ["-"],
    ["-"],
    ["-"],
    ["-"],
    ["-"]
  ];
  List<TextEditingController> _amountControler = [
    TextEditingController(),
  ];
  List<Product> _product = [];
  List<List<String>> _batches = [
    ["-"]
  ];
  List<Widget> _buildedColumn;

  @override
  void dispose() {
    _paynmentControler.dispose();
    for (int i = 0; i < _amountControler.length; i++) {
      _amountControler[i].dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _items = fetchProducts();
    super.didChangeDependencies();
  }

  Future<List<Product>> _items;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildColumn(List<Product> products) {
      List<Widget> _output = [];
      List<String> _products = ["-"];

      for (int i = 0; i < products.length; i++) {
        _products.add(products[i].name + "-" + products[i].manufacturer);
        if (_product.length <= _products.length - 2) {
          _product.add(products[i]);
        }
      }

      for (int i = 0; i < _itemCount; i++) {
        _output.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: DropdownButton<String>(
                value: _productControler[i][0],
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
                    _batches[i] = ["-"];
                    _batchControler[i][0] = "-";
                    _productControler[i][0] = newValue;
                    for (int k = 0; k < products.length; k++) {
                      if (newValue ==
                          products[k].name + "-" + products[k].manufacturer) {
                        for (int j = 0; j < products[k].batches.length; j++) {
                          _batches[i].add(products[k].batches[j].id);
                        }
                      }
                    }
                  });
                },
                items: _products.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              width: 200,
              height: 80,
            ),
            Container(
              child: DropdownButton<String>(
                value: _batchControler[i][0],
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
                    _batchControler[i][0] = newValue;
                  });
                },
                items:
                    _batches[i].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              width: 200,
              height: 80,
            ),
            Container(
              child: TextField(
                controller: _amountControler[i],
                decoration: InputDecoration(
                    labelText: 'Quantidade',
                    contentPadding: EdgeInsets.all(40),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
              ),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              width: 200,
              height: 80,
            )
          ],
        ));
      }
      return _output;
    }

    final List<Widget> _initItems = [
      Container(
          padding: EdgeInsets.only(bottom: 25),
          child: Text(
            "Nova Venda",
            style: TextStyle(color: Colors.greenAccent),
            textScaleFactor: 3,
          )),
      Container(
        child: TextField(
          controller: _paynmentControler,
          decoration: InputDecoration(
              labelText: 'Modo de Pagamento',
              contentPadding: EdgeInsets.all(40),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB3FFBB)))),
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        width: 400,
        height: 80,
      )
    ];

    final List<Widget> _finalItems = [
      FlatButton(
        child: Text('+'),
        color: Colors.greenAccent,
        onPressed: () {
          setState(() {
            _itemCount++;
            _amountControler.add(TextEditingController());
            _batchControler.add(["-"]);
            _productControler.add(["-"]);
            _batches.add(["-"]);
          });
        },
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
              _paynmentControler.clear();
              for (int i = 0; i < _amountControler.length; i++) {
                _amountControler[i].clear();
              }
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Criar',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.greenAccent,
            onPressed: () {
              List<int> _amounts = [];
              double _price = 0;
              for (int i = 0; i < _amountControler.length; i++) {
                _amounts.add(int.tryParse(_amountControler[i].text));
                for (int j = 0; j < _product.length; j++) {
                  if (_productControler[i][0] ==
                      _product[j].name + "-" + _product[j].manufacturer) {
                    _price += int.tryParse(_amountControler[i].text) *
                        _product[j].price;
                  }
                }
              }
              print(_paynmentControler.text);
              createSales(
                  _paynmentControler.text, _price, _batchControler, _amounts);
              _paynmentControler.clear();
              for (int i = 0; i < _amountControler.length; i++) {
                _amountControler[i].clear();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    ];

    final Widget _future = FutureBuilder(
        future: _items,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          _buildedColumn = _buildColumn(snapshot.data);
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _initItems + _buildedColumn + _finalItems,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });

    final Widget _primary = Material(
        child: Center(
            child: Container(
      child: _future,
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 1.2,
    )));
    return _primary;
  }
}
