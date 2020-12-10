import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

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

  void addOrders(List<CartItem> cartProd, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          dateTime: DateTime.now(),
          amount: total,
          product: cartProd),
    );
    notifyListeners();
  }
}
