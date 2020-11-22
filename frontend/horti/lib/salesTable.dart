import 'package:horti/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:horti/schemas.dart';
import 'package:horti/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesTable extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SalesTable> {
  @override
  void dispose() {
    super.dispose();
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  //int _rowsPerPage = 2;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void didChangeDependencies() {
    _items = fetchSales();
    super.didChangeDependencies();
  }

  Future<List<Sales>> _items;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    Widget _datatable(List<Sales> _items) {
      void _sort<T>(
          Comparable<T> getField(Sales d), int columnIndex, bool ascending) {
        _items.sort((Sales a, Sales b) {
          if (!ascending) {
            final Sales c = a;
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
                    'http://localhost:8000/sales/${item.id}',
                    headers: {'Authorization': _token});

                if (response.statusCode == 200) {
                  showToast("Venda deletada.", position: ToastPosition.bottom);
                  setState(() {});
                }
              }
            });
          },
        );

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
          final Sales user = _items[index];
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
                DataCell(Text('${user.id}')),
                DataCell(Text('${user.products}')),
                DataCell(Text('${user.totalPrice}')),
                DataCell(Text('${user.paynment}')),
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
        actions: [],
        selectedActions: _selectedActions(),
        columns: <DataColumn>[
          DataColumn(label: const Text('ID')),
          DataColumn(label: const Text('Produtos')),
          DataColumn(
            label: const Text('Preço'),
          ),
          DataColumn(
            label: const Text('Pagamento'),
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
                (BuildContext context, AsyncSnapshot<List<Sales>> snapshot) {
              if (snapshot.hasData) {
                var _filteredNames = snapshot.data;
                return _datatable(_filteredNames);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }));
  }
}
