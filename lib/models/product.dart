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
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] == 0) 
          ? 0.0
          : (json['price'] is int) 
              ? (json['price'] as int).toDouble() 
              : (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] == 0)
          ? 0.0
          : (json['discountPercentage'] is int)
              ? (json['discountPercentage'] as int).toDouble()
              : (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] == 0)
          ? 0.0
          : (json['rating'] is int)
              ? (json['rating'] as int).toDouble()
              : (json['rating'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}