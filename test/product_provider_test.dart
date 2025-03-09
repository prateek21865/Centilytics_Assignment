import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/models/product.dart';

void main() {
  group('ProductProvider Tests', () {
    late ProductProvider productProvider;
    late List<Product> testProducts;

    setUp(() {
      productProvider = ProductProvider();
      testProducts = [
        Product(
          id: 1,
          title: 'Test Product 1',
          description: 'Description 1',
          price: 99.99,
          discountPercentage: 10.0,
          rating: 4.5,
          stock: 50,
          brand: 'Brand 1',
          category: 'electronics',
          thumbnail: 'https://example.com/thumb1.jpg',
          images: ['https://example.com/1.jpg'],
        ),
        Product(
          id: 2,
          title: 'Test Product 2',
          description: 'Description 2',
          price: 149.99,
          discountPercentage: 15.0,
          rating: 4.0,
          stock: 30,
          brand: 'Brand 2',
          category: 'electronics',
          thumbnail: 'https://example.com/thumb2.jpg',
          images: ['https://example.com/2.jpg'],
        ),
        Product(
          id: 3,
          title: 'Test Product 3',
          description: 'Description 3',
          price: 199.99,
          discountPercentage: 5.0,
          rating: 4.8,
          stock: 20,
          brand: 'Brand 3',
          category: 'clothing',
          thumbnail: 'https://example.com/thumb3.jpg',
          images: ['https://example.com/3.jpg'],
        ),
      ];
    });

    test('should set and get products', () {
      productProvider.setProducts(testProducts);
      
      expect(productProvider.products.length, 3);
      expect(productProvider.products[0].id, 1);
    });

    test('should get similar products', () {
      productProvider.setProducts(testProducts);
      
      final similarProducts = productProvider.getSimilarProducts(testProducts[0]);
      
      expect(similarProducts.length, 1);
      expect(similarProducts[0].id, 2);
      expect(similarProducts[0].category, 'electronics');
    });

    test('should respect limit parameter in getSimilarProducts', () {
      productProvider.setProducts(testProducts);
      
      final similarProducts = productProvider.getSimilarProducts(testProducts[0], limit: 1);
      
      expect(similarProducts.length, 1);
    });

    test('should not include the same product in similar products', () {
      productProvider.setProducts(testProducts);
      
      final similarProducts = productProvider.getSimilarProducts(testProducts[0]);
      
      expect(similarProducts.any((p) => p.id == testProducts[0].id), false);
    });
  });
}