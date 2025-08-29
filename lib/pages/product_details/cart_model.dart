import 'package:flutter/material.dart';
import 'package:myntra/models/CategoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartItem {
  final CategoryItem item;
  final String size;
  int quantity;
  CartItem({required this.item, required this.size, required this.quantity});

  // Two items are equal if their product and size match
  @override
  bool operator ==(Object other) =>
      other is CartItem && item == other.item && size == other.size;

  @override
  int get hashCode => item.hashCode ^ size.hashCode;
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int _cartCount = 0;
  int get cartCount => _cartCount;

  CartModel() {
    _loadCartCount();
    _loadCartItems(); // ✅ Load full cart items
  }

  Future<void> _loadCartCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartCount = prefs.getInt('cartCount') ?? 0;
    notifyListeners();
  }

  Future<void> _saveCartCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartCount', _cartCount);
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonList = _items
        .map(
          (cartItem) => jsonEncode({
            'itemName': cartItem.item.name,
            'price': cartItem.item.price,
            'size': cartItem.size,
            'quantity': cartItem.quantity,
            'productImages': cartItem.item.productImages,
            'averageRatingStr': cartItem.item.averageRatingStr,
            'ratingCount': cartItem.item.ratingCount,
            'reviewCount': cartItem.item.reviewCount,
            'fullDetails': cartItem.item.fullDetails,
          }),
        )
        .toList();

    await prefs.setStringList('cartItems', cartJsonList);
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonList = prefs.getStringList('cartItems') ?? [];

    _items.clear();
    for (var itemJson in cartJsonList) {
      final map = jsonDecode(itemJson);
      final categoryItem = CategoryItem(
        id: map['id'] ?? 0, // default int
        heroPid: map['heroPid'] ?? 0, // default int
        categoryId: map['categoryId'] ?? 0, // default int
        assured: map['assured'] ?? false, // default bool
        name: map['itemName'] ?? '',
        price: map['price'] ?? 0,
        productImages: List<String>.from(map['productImages'] ?? []),
        averageRatingStr: map['averageRatingStr'] ?? '',
        ratingCount: map['ratingCount'] ?? 0,
        reviewCount: map['reviewCount'] ?? 0,
        fullDetails: map['fullDetails'] ?? '',
      );

      _items.add(
        CartItem(
          item: categoryItem,
          size: map['size'],
          quantity: map['quantity'],
        ),
      );
    }
    _recomputeAndPersistCount();
    notifyListeners();
  }

  void _recomputeAndPersistCount() {
    _cartCount = _items.fold(0, (sum, item) => sum + item.quantity);
    _saveCartCount();
  }

  void addItem(CategoryItem item, String size, int quantity) {
    // Merge logic: if item with this size exists, just update quantity
    final index = _items.indexWhere((ci) => ci.item == item && ci.size == size);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(item: item, size: size, quantity: quantity));
    }
    _saveCartItems();
    _recomputeAndPersistCount();
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    _saveCartItems();
    _recomputeAndPersistCount();
    notifyListeners();
  }

  void updateItemQuantity(CartItem cartItem, int newQuantity) {
    final index = _items.indexOf(cartItem);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      if (newQuantity <= 0) {
        _items.removeAt(index);
      }
      _saveCartItems();
      _recomputeAndPersistCount();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCartItems();
    _recomputeAndPersistCount();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(
      0,
      (sum, cartItem) => sum + cartItem.item.price * cartItem.quantity,
    );
  }
}
