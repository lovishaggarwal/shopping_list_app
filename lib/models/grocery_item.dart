import 'package:shoppingListApp/models/category.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  final String id;
  final String name;
  final int quantity;
  final Category category;

  // Copy method to create a new object with an updated ID
  GroceryItem copyWith(
      {String? id, String? name, int? quantity, Category? category}) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}
