import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Man', 'Woman', 'Shirts', 'Pants', 'Outfits'];

  double _maxPrice = 20000;
  double get maxPrice => _maxPrice;

  String _sortBy = 'Newest';
  String get sortBy => _sortBy;

  ProductController() {
    _initProducts();
  }

  Future<void> _initProducts() async {
    _isLoading = true;
    notifyListeners();
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 1800));
    _loadMockProducts();
    _isLoading = false;
    notifyListeners();
  }

  void _loadMockProducts() {
    _products = [
      ProductModel(
        id: 'p1',
        name: 'Classic Black Suit',
        description: 'A premium wool-blend black suit, perfectly tailored for formal occasions.',
        price: 12500,
        category: 'Man',
        imageUrl: 'https://images.unsplash.com/photo-1594932224010-75f4177a28cb?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1594932224010-75f4177a28cb?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1593032465175-481ac7f401a0?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1598808503746-f34c53b9323e?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.8,
        reviews: 24,
      ),
      ProductModel(
        id: 'p2',
        name: 'Floral Summer Dress',
        description: 'Lightweight and feminine floral dress for sunny days.',
        price: 4500,
        category: 'Woman',
        imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.5,
        reviews: 42,
      ),
      ProductModel(
        id: 'p3',
        name: 'Denim Canvas Shirt',
        description: 'Durable denim shirt with a modern slim fit.',
        price: 2800,
        category: 'Shirts',
        imageUrl: 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1589310243389-94a551834c3c?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.2,
        reviews: 15,
      ),
      ProductModel(
        id: 'p4',
        name: 'Chino Trousers',
        description: 'Versatile cotton chinos in a classic beige color. Perfect for semi-formal looks.',
        price: 3200,
        category: 'Pants',
        imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.4,
        reviews: 28,
      ),
      ProductModel(
        id: 'p5',
        name: 'Evening Gala Outfit',
        description: 'Complete outfit for black-tie events, including accessories and fine detailing.',
        price: 18000,
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1539109132332-629263ef71d1?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1539109132332-629263ef71d1?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.9,
        reviews: 10,
      ),
      ProductModel(
        id: 'p6',
        name: 'Leather Weekend Jacket',
        description: 'Premium leather jacket for a rugged yet stylish look.',
        price: 9500,
        category: 'Man',
        imageUrl: 'https://images.unsplash.com/photo-1551028711-131da507bd89?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1551028711-131da507bd89?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.7,
        reviews: 35,
      ),
      ProductModel(
        id: 'p7',
        name: 'Boho Summer Dress',
        description: 'Flowy and stylish bohemian style dress for outdoor gatherings.',
        price: 5200,
        category: 'Woman',
        imageUrl: 'https://images.unsplash.com/photo-1496740949703-da99dd740df0?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1496740949703-da99dd740df0?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.6,
        reviews: 18,
      ),
      ProductModel(
        id: 'p8',
        name: 'Silk Party Top',
        description: 'Elegant silk top with a subtle sheen, perfect for evening wear.',
        price: 3800,
        category: 'Woman',
        imageUrl: 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.3,
        reviews: 22,
      ),
      ProductModel(
        id: 'p9',
        name: 'Linen Casual Shirt',
        description: 'Breathable linen shirt for maximum comfort in warm weather.',
        price: 2400,
        category: 'Shirts',
        imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&q=80&w=800',
          'https://images.unsplash.com/photo-1589310243389-94a551834c3c?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.1,
        reviews: 12,
      ),
      ProductModel(
        id: 'p10',
        name: 'Oxford Button Down',
        description: 'Classic Oxford shirt, a staple for every wardrobe.',
        price: 3100,
        category: 'Shirts',
        imageUrl: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.5,
        reviews: 50,
      ),
      ProductModel(
        id: 'p11',
        name: 'Cargo Utility Pants',
        description: 'Multi-pocket cargo pants for a modern utility look.',
        price: 4200,
        category: 'Pants',
        imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.4,
        reviews: 19,
      ),
      ProductModel(
        id: 'p12',
        name: 'Slim Fit Trousers',
        description: 'Sleek slim-fit trousers for a professional appearance.',
        price: 5500,
        category: 'Pants',
        imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.7,
        reviews: 8,
      ),
      ProductModel(
        id: 'p13',
        name: 'Street Style Set',
        description: 'Matching top and bottom set for an urban fashion aesthetic.',
        price: 8800,
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1617137934033-5471b9222a55?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1617137934033-5471b9222a55?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.6,
        reviews: 14,
      ),
      ProductModel(
        id: 'p14',
        name: 'Modern Blazer Set',
        description: 'Contemporary blazer and trousers combination for high fashion.',
        price: 15600,
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.9,
        reviews: 5,
      ),
      ProductModel(
        id: 'p15',
        name: 'Sporty Activewear',
        description: 'Performance-focused activewear for your daily workout.',
        price: 6400,
        category: 'Man',
        imageUrl: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&q=80&w=800',
        images: [
          'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&q=80&w=800',
        ],
        rating: 4.5,
        reviews: 30,
      ),
    ];
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void applyFilters({double? maxPrice, String? sortBy}) {
    if (maxPrice != null) _maxPrice = maxPrice;
    if (sortBy != null) _sortBy = sortBy;
    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    List<ProductModel> results = _products;

    if (_selectedCategory != 'All') {
      results = results.where((p) => p.category == _selectedCategory).toList();
    }

    results = results.where((p) => p.price <= _maxPrice).toList();

    if (_sortBy == 'Price: Low to High') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      results.sort((a, b) => b.price.compareTo(a.price));
    }
    // 'Newest' would need a date field, skipping for now as it's the default order

    return results;
  }

  ProductModel getProductById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }
}
