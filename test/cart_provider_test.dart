import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/models/product.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    late Product testProduct;

    setUp(() {
      cartProvider = CartProvider();
      testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        discountPercentage: 10.0,
        rating: 4.5,
        stock: 50,
        brand: 'Test Brand',
        category: 'electronics',
        thumbnail: 'https://example.com/thumb.jpg',
        images: ['https://example.com/1.jpg'],
      );
    });

    test('should add item to cart', () {
      cartProvider.addItem(testProduct);
      
      expect(cartProvider.items.length, 1);
      expect(cartProvider.items[1]?.quantity, 1);
    });

    test('should increase quantity when adding same item', () {
      cartProvider.addItem(testProduct);
      cartProvider.addItem(testProduct);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items[1]?.quantity, 2);
    });

    test('should calculate total amount correctly', () {
      cartProvider.addItem(testProduct);
      cartProvider.addItem(testProduct);

      expect(cartProvider.totalAmount, 199.98);
    });

    test('should remove item from cart', () {
      cartProvider.addItem(testProduct);
      cartProvider.removeItem(1);

      expect(cartProvider.items.isEmpty, true);
    });

    test('should update quantity', () {
      cartProvider.addItem(testProduct);
      cartProvider.updateQuantity(1, 3);

      expect(cartProvider.items[1]?.quantity, 3);
    });

    test('should remove item when quantity is set to 0', () {
      cartProvider.addItem(testProduct);
      cartProvider.updateQuantity(1, 0);

      expect(cartProvider.items.isEmpty, true);
    });

    test('should clear cart', () {
      cartProvider.addItem(testProduct);
      cartProvider.clear();

      expect(cartProvider.items.isEmpty, true);
    });
  });
}