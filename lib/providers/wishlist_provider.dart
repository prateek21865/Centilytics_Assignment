import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product.dart';

class WishlistProvider with ChangeNotifier {
  final Set<Product> _items = {};

  Set<Product> get items => {..._items};

  int get itemCount => _items.length;

  bool isInWishlist(int productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}