import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import 'package:horti/schemas.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<User>> fetchUsers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response = await http
      .get('http://localhost:8000/user', headers: {'Authorization': _token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<bool> updateUser(String id, String name, String pwd, String role,
    String email, String phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');

  var requestBody =
      '{"Name": "$name", "Password": "$pwd","Role":"$role","Email":"$email","Phone":"$phone"}';
  if (pwd == "anything") {
    requestBody =
        '{"Name": "$name", "Role":"$role","Email":"$email","Phone":"$phone"}';
  }
  var response = await http.put('http://localhost:8000/user/$id',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    showToast("Usuário atualizado com sucesso.",
        position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível atualizar o usuário.",
        position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}

Future<bool> createUser(
    String name, String pwd, String role, String email, String phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var requestBody =
      '{"Name": "$name", "Password": "$pwd","Role":"$role","Email":"$email","Phone":"$phone"}';
  var response = await http.post('http://localhost:8000/user',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    showToast("Usuário criado com sucesso.", position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível criar o usuário.",
        position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}

Future<bool> createProduct(
    String name, double price, String manufacturer, int daysToExpirate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var requestBody =
      '{"Name": "$name", "Price": $price,"Manufacturer":"$manufacturer","DaysToExpirate":$daysToExpirate}';
  var response = await http.post('http://localhost:8000/products',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    showToast("Produto criado com sucesso.", position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível criar o produto.",
        position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}

Future<bool> updateProduct(String id, String name, double price,
    String manufacturer, int daysToExpirate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');

  var requestBody =
      '{"Name": "$name", "Price": $price,"Manufacturer":"$manufacturer","DaysToExpirate":$daysToExpirate}';

  var response = await http.put('http://localhost:8000/products/$id',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    showToast("Usuário atualizado com sucesso.",
        position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível atualizar o usuário.",
        position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}

Future<List<Product>> fetchProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response = await http.get('http://localhost:8000/products',
      headers: {'Authorization': _token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<List<dynamic>> fetchBatchesAndProducts() async {
  List<dynamic> result = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response1 = await http
      .get('http://localhost:8000/batches', headers: {'Authorization': _token});

  var response2 = await http.get('http://localhost:8000/products',
      headers: {'Authorization': _token});

  if (response1.statusCode == 200 && response2.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed1 = json.decode(response1.body).cast<Map<String, dynamic>>();
    result.add(parsed1.map<Batch>((json) => Batch.fromJson(json)).toList());

    final parsed2 = json.decode(response2.body).cast<Map<String, dynamic>>();
    result.add(parsed2.map<Product>((json) => Product.fromJson(json)).toList());

    return result;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<Product> fetchProductbyID(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response = await http.get('http://localhost:8000/products/$id',
      headers: {'Authorization': _token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map parsed = json.decode(response.body);
    //final parsed = json.decode(response.body).cast<String, dynamic>();
    return Product.fromJson(parsed);
    //return parsed.map<Product>((json) => Product.fromJson(json));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<Batch> fetchBatchbyID(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response = await http.get('http://localhost:8000/batches/$id',
      headers: {'Authorization': _token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map parsed = json.decode(response.body);
    //final parsed = json.decode(response.body).cast<String, dynamic>();
    return Batch.fromJson(parsed);
    //return parsed.map<Product>((json) => Product.fromJson(json));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<bool> createBatch(String productID, int totalAmount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var requestBody =
      '{"ProductID": "$productID", "TotalAmount": $totalAmount,"Expirated":false,"FinalAmount":$totalAmount}';
  var response = await http.post('http://localhost:8000/batches',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    showToast("Lote adicionado com sucesso.", position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível criar lote.", position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}

Future<List<Sales>> fetchSales() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var response = await http
      .get('http://localhost:8000/sales', headers: {'Authorization': _token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    var sales = parsed.map<Sales>((json) => Sales.fromJson(json)).toList();
    for (var i = 0; i < sales.length; i++) {
      for (var j = 0; j < sales[i].soldProducts.length; j++) {
        var batch = await fetchBatchbyID(sales[i].soldProducts[j].batchID);
        var productName = await fetchProductbyID(batch.productID);
        sales[i].products.add(productName.name);
      }
    }
    return sales;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    return null;
  }
}

Future<bool> createSales(String paynment, double totalPrice,
    List<List<String>> batches, List<int> amounts) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString('token');
  var requestBody = '{"TotalPrice": $totalPrice, "Paynment": "$paynment"}';
  var response = await http.post('http://localhost:8000/sales',
      headers: {'Authorization': _token}, body: requestBody);

  if (response.statusCode == 200) {
    var salesID = response.body;
    // If the server did return a 200 OK response,
    // then parse the JSON.
    for (var i = 0; i < amounts.length; i++) {
      var requestBody =
          '{"BatchID": "${batches[i][0]}", "SalesID": "$salesID", "Amount": ${amounts[i]}}';
      var response2 = await http.post('http://localhost:8000/sold-products',
          headers: {'Authorization': _token}, body: requestBody);
    }
    showToast("Venda adicionada com sucesso.", position: ToastPosition.bottom);
    return true;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Something error occured');
    showToast("Não foi possível criar venda.", position: ToastPosition.bottom);
    print(response.body);
    return false;
  }
}
