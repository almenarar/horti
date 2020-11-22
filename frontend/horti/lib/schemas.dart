import 'package:intl/intl.dart';

class Batch {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String deleteAt;
  final int totalAmount;
  final int finalAmount;
  final bool expirated;
  final String productID;

  Batch(
      {this.createdAt,
      this.deleteAt,
      this.expirated,
      this.finalAmount,
      this.id,
      this.productID,
      this.totalAmount,
      this.updatedAt});

  factory Batch.fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat.yMd().add_jm();
    return Batch(
        productID: json['ProductID'],
        id: json['ID'],
        createdAt: json['CreatedAt'],
        updatedAt:
            formatter.format(DateTime.parse(json['UpdatedAt']).toLocal()),
        totalAmount: json['TotalAmount'],
        finalAmount: json['FinalAmount'],
        expirated: json['Expirated']);
  }
}

class Product {
  final String name;
  final String id;
  final String createdAt;
  final String updatedAt;
  final String deleteAt;
  final double price;
  final int daysToExpirate;
  final String manufacturer;
  final List<Batch> batches;

  bool selected = false;

  Product(
      {this.name,
      this.manufacturer,
      this.daysToExpirate,
      this.price,
      this.createdAt,
      this.deleteAt,
      this.id,
      this.updatedAt,
      this.batches});

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Batch> batches = [];
    if (json['Batch'] != null) {
      for (var i = 0; i < json['Batch'].length; i++) {
        batches.add(Batch.fromJson(json['Batch'][i]));
      }
    }
    return Product(
        name: json['Name'],
        id: json['ID'],
        createdAt: json['CreatedAt'],
        updatedAt: json['UpdatedAt'],
        //deleteAt: DateTime.parse(json['DeleteAt']),
        price: json['Price'],
        daysToExpirate: json['DaysToExpirate'],
        manufacturer: json['Manufacturer'],
        batches: batches);
  }
}

class User {
  final String name;
  final String role;
  final String id;
  final String lastLogin;
  final String createdAt;
  final String email;
  final String phone;

  bool selected = false;

  User(
      {this.name,
      this.role,
      this.id,
      this.lastLogin,
      this.createdAt,
      this.email,
      this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat.yMd().add_jm();
    return User(
      name: json["Name"],
      role: json["Role"],
      id: json["ID"],
      createdAt: formatter.format(DateTime.parse(json['CreatedAt']).toLocal()),
      lastLogin: formatter.format(DateTime.parse(json['LastLogin']).toLocal()),
      email: json["Email"],
      phone: json["Phone"],
    );
  }
}

class Sales {
  final String id;
  final String createdAt;
  final double totalPrice;
  final String paynment;
  final List<SoldProducts> soldProducts;

  List<String> products = [];
  bool selected = false;

  Sales({
    this.id,
    this.createdAt,
    this.paynment,
    this.soldProducts,
    this.totalPrice,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    List<SoldProducts> soldProducts = [];
    if (json['SoldProducts'] != null) {
      for (var i = 0; i < json['SoldProducts'].length; i++) {
        soldProducts.add(SoldProducts.fromJson(json['SoldProducts'][i]));
      }
    }
    final DateFormat formatter = DateFormat.yMd().add_jm();
    return Sales(
        id: json["ID"],
        createdAt:
            formatter.format(DateTime.parse(json['CreatedAt']).toLocal()),
        paynment: json["Paynment"],
        totalPrice: json["TotalPrice"],
        soldProducts: soldProducts);
  }
}

class SoldProducts {
  final String id;
  final String createdAt;
  final int amount;
  final String batchID;
  final String salesID;

  SoldProducts(
      {this.id, this.amount, this.batchID, this.createdAt, this.salesID});

  factory SoldProducts.fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat.yMd().add_jm();
    return SoldProducts(
        id: json["ID"],
        createdAt:
            formatter.format(DateTime.parse(json['CreatedAt']).toLocal()),
        amount: json["Amount"],
        batchID: json["BatchID"],
        salesID: json["SalesID"]);
  }
}
