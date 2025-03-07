import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-dd0cc-default-rtdb.firebaseio.com';
  final List<Product> _items = dummyProducts;
  bool _showFavoritesOnly = false;

  List<Product> get items {
    if(_showFavoritesOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
     final future =http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode({
        "name": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      },
      ),
    ); 
      future.then((response) {
      final id = jsonDecode(response.body)['name'];
      _items.add(Product(
        id: id,
         title: product.title,
          description: product.description,
           price: product.price,
            imageUrl: product.imageUrl,
              isFavorite: product.isFavorite,
            ));
      notifyListeners();
    });

  }
  
  void saveProductFromData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(), 
      title: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl']as String ,
      );
    
    if(hasId) {
      updateProduct(product);
    } else {
      addProduct(product);

    }
  }

    void updateProduct(Product product) {
      int index = _items.indexWhere((p) => p.id == product.id);

      if(index >= 0) {
        _items[index] = product;
        notifyListeners();
      }
    }
    void removeProduct(Product product) {
      int index = _items.indexWhere((p) => p.id == product.id);

      if(index >= 0) {
        _items.removeWhere((p) => p.id == product.id);
        notifyListeners();
      }
    }
}

// bool _showFavoritesOnly = false;

//   List<Product> get items {
//     if(_showFavoritesOnly) {
//       return _items.where((prod) => prod.isFavorite).toList();
//     }
//     return [..._items];
//   }

//   void showFavoritesOnly() {
//     _showFavoritesOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoritesOnly = false;
//     notifyListeners();
//   }
