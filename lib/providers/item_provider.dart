import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppingListApp/models/grocery_item.dart';

class ItemsNotifier extends StateNotifier<List<GroceryItem>> {
  ItemsNotifier() : super([]);

  addItem(GroceryItem item) {
    state = List.from(state)..add(item);
  }

  removeItem(GroceryItem item) {
    state = List.from(state)..remove(item);
  }

  insertItem(int index, GroceryItem item) {
    state = List.from(state)..insert(index, item);
  }
}

final itemProvider =
    StateNotifierProvider<ItemsNotifier, List<GroceryItem>>((ref) {
  return ItemsNotifier();
});
