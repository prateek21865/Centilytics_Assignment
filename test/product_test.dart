import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 99.99,
        'discountPercentage': 10.5,
        'rating': 4.5,
        'stock': 50,
        'brand': 'Test Brand',
        'category': 'electronics',
        'thumbnail': 'https://example.com/thumb.jpg',
        'images': ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.images.length, 2);
    });

    test('should handle missing or null values in JSON', () {
      final json = {
        'id': null,
        'title': null,
        'price': null,
      };

      final product = Product.fromJson(json);

      expect(product.id, 0);
      expect(product.title, '');
      expect(product.price, 0.0);
      expect(product.images, isEmpty);
    });
  });
}