import 'package:horti/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:horti/forms.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:horti/schemas.dart';
import 'package:horti/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  //int _rowsPerPage = 2;
  int _sortColumnIndex;
  bool _sortAscending = true;

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Product> _filteredNames;
  List<Product> _names;

  _ProductsState() {
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
    _items = fetchProducts();
    super.didChangeDependencies();
  }

  Future<List<Product>> _items;
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

    Widget _expirations = Container(
        child: IconButton(
            icon: Icon(Icons.timer, color: Colors.red),
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ExpList();
                    });
              });
            }));

    void _updateProduct(String id) {
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
                          "Atualizar Produto",
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
                                borderSide:
                                    BorderSide(color: Color(0xFFB3FFBB)))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
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
                                        borderSide: BorderSide(
                                            color: Color(0xFFB3FFBB)))),
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
                                        borderSide: BorderSide(
                                            color: Color(0xFFB3FFBB)))),
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
                            updateProduct(
                                id,
                                _productNameControler.text,
                                double.tryParse(_productPriceControler.text),
                                _productManufacturerControler.text,
                                int.tryParse(_productExpirateControler.text));
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

    Widget _datatable(List<Product> _items) {
      void _sort<T>(
          Comparable<T> getField(Product d), int columnIndex, bool ascending) {
        _items.sort((Product a, Product b) {
          if (!ascending) {
            final Product c = a;
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
                    'http://localhost:8000/products/${item.id}',
                    headers: {'Authorization': _token});

                if (response.statusCode == 200) {
                  showToast("Produto deletado.",
                      position: ToastPosition.bottom);
                  setState(() {});
                }
              }
            });
          },
        );

        int len = 0;
        Product item;
        for (var Product
            in _items.where((element) => element.selected == true)) {
          ++len;
          item = Product;
        }
        if (len == 1) {
          final _edit = IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _productNameControler =
                      TextEditingController(text: item.name);
                  _productPriceControler =
                      TextEditingController(text: item.price.toString());
                  _productExpirateControler = TextEditingController(
                      text: item.daysToExpirate.toString());
                  _productManufacturerControler =
                      TextEditingController(text: item.manufacturer);
                  _updateProduct(item.id);
                });
              });

          final _seeBatches = RaisedButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BatchList(productID: item.id);
                    });
              });
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Lotes Ativos",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );

          final _addBatch = RaisedButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BatchForm(productID: item.id);
                    });
              });
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Novo Lote",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
          return [_addBatch, _seeBatches, _edit, _delete];
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
          final Product product = _items[index];
          final DateFormat formatter = DateFormat.yMd().add_jm();
          return DataRow.byIndex(
              index: index,
              selected: product.selected,
              onSelectChanged: (bool value) {
                if (product.selected != value) {
                  setState(() {
                    product.selected = value;
                  });
                }
              },
              cells: <DataCell>[
                DataCell(Text('${product.name}')),
                DataCell(Text('${product.price}')),
                DataCell(Text('${product.daysToExpirate}')),
                DataCell(Text('${product.manufacturer}')),
                DataCell(Text(formatter
                    .format(DateTime.parse(product.createdAt).toLocal()))),
                DataCell(Text(formatter
                    .format(DateTime.parse(product.updatedAt).toLocal()))),
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
        actions: <Widget>[_searchBar, _expirations],
        selectedActions: _selectedActions(),
        columns: <DataColumn>[
          DataColumn(
              label: const Text('Nome'),
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>((Product d) => d.name, columnIndex, ascending)),
          DataColumn(label: const Text('Preço'), numeric: true),
          DataColumn(
            label: const Text('Validade em Dias'),
            numeric: true,
          ),
          DataColumn(
              label: const Text('Fornecedor'),
              onSort: (int columnIndex, bool ascending) => _sort<String>(
                  (Product d) => d.manufacturer, columnIndex, ascending)),
          DataColumn(
            label: const Text('Data de Criação'),
          ),
          DataColumn(
            label: const Text('Atualizado em'),
          ),
        ],
      );
    }

    return Material(
        child: FutureBuilder(
            future: _items,
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              if (snapshot.hasData) {
                _filteredNames = snapshot.data;
                if ((_searchText.isNotEmpty)) {
                  List<Product> tempList = new List();
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
