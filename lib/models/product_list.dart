import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';
import '../exceptions/http_exception.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-dd0cc-default-rtdb.firebaseio.com/products';
  final List<Product> _items = [];
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

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('$_baseUrl.json',),
      );
    if(response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData){
      _items.add(Product(
        id: productId, 
        title: productData['name'], 
        description: productData['description'], 
        price: productData['price'], 
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
        ));
    });
    notifyListeners();
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
     final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode({
        "name": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      },
      ),
    ); 
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

  }
  
  Future<void> saveProductFromData(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(), 
      title: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl']as String ,
      );
    
    if(hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

    Future<void> updateProduct(Product product) async {
      int index = _items.indexWhere((p) => p.id == product.id);

      if(index >= 0) {
        await http.patch(
          Uri.parse('$_baseUrl/${product.id}.json'),
           body: jsonEncode({
              "name": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
        },
      ),
    ); 
        _items[index] = product;
        notifyListeners();
      }
    }

    Future<void> removeProduct(Product product) async {
      int index = _items.indexWhere((p) => p.id == product.id);

      if(index >= 0) {
        final product = _items[index];
        _items.remove(product);
        notifyListeners();
        final response = await http.delete(
          Uri.parse('$_baseUrl/${product.id}.json'),
        ); 

        if(response.statusCode >= 400) {
          _items.insert(index, product);
          notifyListeners();
          throw HttpException(
            msg: 'Não foi possível excluir o produto',
            statusCode: response.statusCode,
          );
        }
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
