class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviews;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.images,
    this.rating = 4.5,
    this.reviews = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviews: json['reviews'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'images': images,
      'rating': rating,
      'reviews': reviews,
    };
  }
}
