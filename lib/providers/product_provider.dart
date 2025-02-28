import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  List<Product> getSimilarProducts(Product product, {int limit = 6}) {
    return _products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(limit)
        .toList();
  }
}