import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  int? id;
  String? name;
  String? price;
  int? quantity;

  Product({this.id, this.name, this.price, this.quantity});

  static Product fromMap(Map<String, dynamic> Query) {
    Product product = Product();
    product.id = Query['id'];
    product.name = Query['id'];
    product.price = Query['name'];
    product.quantity = Query['quantity'];
    return product;
  }

  static Map<dynamic, dynamic> toMap(Product product) {
    return <String, dynamic>{
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
    };
  }

  static List<Product> fromList(List<Map<String, dynamic>> query) {
    List<Product> products = [];
    for (final map in query) {
      products.add(fromMap(map));
    }
    return products;
  }
}
