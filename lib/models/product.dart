class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']) ?? 0.0,
      discountPercentage: _parseDouble(json['discountPercentage']) ?? 0.0,
      rating: _parseDouble(json['rating']) ?? 0.0,
      stock: json['stock']?.toInt() ?? 0,
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  // Helper method to safely parse doubles from various numeric types or null
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
