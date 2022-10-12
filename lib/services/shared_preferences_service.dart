import 'dart:convert';

import 'package:firebasetest/product/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future saveStringToShareedferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future saveBoolToShareedferences(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<String?> getStringFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool?> getBoolFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? boolValue = prefs.getBool(key);
    return boolValue;
  }

  static saveProduct() async {
    Product product =
        Product(id: 1, name: 'Laptop', price: '2000', quantity: 3);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('product', json.encode(product));

    print(json.decode(prefs.getString('product') ?? ""));
  }
}
