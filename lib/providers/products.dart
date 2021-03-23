import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._items = const [], this._userId]);

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$BASE_URL/products.json?auth=$_token');
    final favResponse = await http.get('$BASE_URL/userFavorites/$_userId.json?auth=$_token');
    final favMap = json.decode(favResponse.body);

    Map<String, dynamic> data = json.decode(response.body);

    if (data == null) return;

    _items.clear();

    data.forEach((key, value) {
      final isFavorite = favMap == null ? false : favMap[key] ?? false;
      _items.add(
        Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {

    final response = await http.post(
      '$BASE_URL/products.json?auth=$_token',
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        '$BASE_URL/products/${product.id}.json?auth=$_token',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete('$BASE_URL/products/${product.id}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro ao tentar excluir o produto');
      }
    }
  }
}
