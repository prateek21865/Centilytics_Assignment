import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:ecommerce_app/widgets/category_chip.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:ecommerce_app/providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products?limit=100'),
      );
      // print('API Response Status Code: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load products: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['products'] == []) {
        throw Exception('Products data is null');
      }

      final List<Product> products = (data['products'] as List)
          .where((product) =>
              product != [] &&
              product['title'] != [] &&
              product['description'] != [] &&
              product['category'] != [])
          .map((product) => Product.fromJson(product))
          .toList();

      // print('Parsed Products Length: ${products.length}');

      final categories =
          products.map((product) => product.category).toSet().toList();

      setState(() {
        _products = products;
        _categories = categories;
        _isLoading = false;
        context.read<ProductProvider>().setProducts(products);
      });
    } catch (error) {
      // print('Error fetching products: $error');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: $error')),
        );
      }
    }
  }

  late List<Product> _filteredProducts;

  @override
  Widget build(BuildContext context) {
    _filteredProducts = _products.where((product) {
      final matchesSearch = product.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'all' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopHub',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: material.Icon(wishlistProvider.items.isEmpty
                    ? material.Icons.favorite_outline
                    : material.Icons.favorite),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ),
              ),
              if (wishlistProvider.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const material.BoxDecoration(
                      color: material.Colors.red,
                      shape: material.BoxShape.circle,
                    ),
                    child: Text(
                      '${wishlistProvider.items.length}',
                      style: const material.TextStyle(
                        color: material.Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon:
                    const material.Icon(material.Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const material.BoxDecoration(
                      color: material.Colors.red,
                      shape: material.BoxShape.circle,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const material.TextStyle(
                        color: material.Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: material.Column(
        children: [
          material.Padding(
            padding: const material.EdgeInsets.all(16),
            child: material.TextField(
              controller: _searchController,
              decoration: material.InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const material.Icon(material.Icons.search),
                border: material.OutlineInputBorder(
                  borderRadius: material.BorderRadius.circular(12),
                  borderSide: material.BorderSide.none,
                ),
                filled: true,
                fillColor: material.Colors.white,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                CategoryChip(
                  label: 'All Products',
                  isSelected: _selectedCategory == 'all',
                  onTap: () => setState(() => _selectedCategory = 'all'),
                ),
                ..._categories.map((category) => CategoryChip(
                      label: category,
                      isSelected: _selectedCategory == category,
                      onTap: () => setState(() => _selectedCategory = category),
                    )),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filteredProducts.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No products found',
                  style: material.TextStyle(
                      fontSize: 18, color: material.Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: MasonryGridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: _filteredProducts[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
