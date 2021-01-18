import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.dateTime, this.product});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProd, double total) async {
    const url =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/orders.json";
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'product': cartProd
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: jsonDecode(response.body)['name'],
          dateTime: timestamp,
          amount: total,
          product: cartProd),
    );
    notifyListeners();
  }
}
