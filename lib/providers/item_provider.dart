import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppingListApp/data/categories.dart';
import 'package:shoppingListApp/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class ItemsNotifier extends StateNotifier<List<GroceryItem>> {
  ItemsNotifier() : super([]) {
    loadItems();
  }

  String errorMessage = '';

  bool isLoading = false;

  final Uri url = Uri.https(
      'shopping-list-app-c05ac-default-rtdb.firebaseio.com',
      'shopping-list.json');

  addItem(GroceryItem item) async {
    isLoading = true;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'name': item.name,
          'quantity': item.quantity,
          'category': item.category.title,
        },
      ),
    );
    GroceryItem newIdItem =
        item.copyWith(id: json.decode(response.body)['name']);
    // print(json.decode(response.body)['name']);
    state = List.from(state)..add(newIdItem);
    isLoading = false;
  }

  removeItem(GroceryItem item) {
    state = List.from(state)..remove(item);
  }

  removeFromFirebase(GroceryItem item) {
    final Uri url = Uri.https(
        'shopping-list-app-c05ac-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    http.delete(url);
  }

  insertItem(int index, GroceryItem item) {
    state = List.from(state)..insert(index, item);
  }

  loadItems() async {
    isLoading = true;
    try {
      final response = await http.get(url);
      isLoading = false;
      if (response.body == 'null') {
        state = [];
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);

      for (final item in listData.entries) {
        final caterory = categories.entries.firstWhere(
            (catItem) => catItem.value.title == item.value['category']);
        state = List.from(state)
          ..add(
            GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: caterory.value,
            ),
          );
      }
    } on Exception catch (e) {
      isLoading = false;
      errorMessage = e.toString();
    }
  }
}

final itemProvider =
    StateNotifierProvider<ItemsNotifier, List<GroceryItem>>((ref) {
  return ItemsNotifier();
});
