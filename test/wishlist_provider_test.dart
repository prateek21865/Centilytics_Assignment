import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:ecommerce_app/models/product.dart';

void main() {
  group('WishlistProvider Tests', () {
    late WishlistProvider wishlistProvider;
    late Product testProduct;

    setUp(() {
      wishlistProvider = WishlistProvider();
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

    test('should toggle item in wishlist', () {
      // Add item
      wishlistProvider.toggleWishlist(testProduct);
      expect(wishlistProvider.items.length, 1);
      expect(wishlistProvider.isInWishlist(1), true);

      // Remove item
      wishlistProvider.toggleWishlist(testProduct);
      expect(wishlistProvider.items.isEmpty, true);
      expect(wishlistProvider.isInWishlist(1), false);
    });

    test('should check if item is in wishlist', () {
      expect(wishlistProvider.isInWishlist(1), false);
      
      wishlistProvider.toggleWishlist(testProduct);
      expect(wishlistProvider.isInWishlist(1), true);
    });

    test('should remove item from wishlist', () {
      wishlistProvider.toggleWishlist(testProduct);
      wishlistProvider.removeItem(1);

      expect(wishlistProvider.items.isEmpty, true);
    });

    test('should get correct item count', () {
      expect(wishlistProvider.itemCount, 0);
      
      wishlistProvider.toggleWishlist(testProduct);
      expect(wishlistProvider.itemCount, 1);
    });
  });
}