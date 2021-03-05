import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.amount,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [...orders];
  }

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
      0,
      Order(
        id: Random().nextBool().toString(),
        amount: total,
        date: DateTime.now(),
        products: products,
      ),
    );

    notifyListeners();
  }
}
