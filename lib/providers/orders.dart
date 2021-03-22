import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config.dart';
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
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      '$BASE_URL/orders.json',
      body: json.encode({
        'amount': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values.map((cartItem) => {
          'id': cartItem.id,
          'productId': cartItem.productId,
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
        }).toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        amount: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
