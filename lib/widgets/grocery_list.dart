import 'package:flutter/material.dart';
import 'package:shoppingListApp/models/grocery_item.dart';
import 'package:shoppingListApp/widgets/grocery_list_item.dart';
import 'package:shoppingListApp/widgets/new_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppingListApp/providers/item_provider.dart';

class GroceryList extends ConsumerWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemNotifier = ref.read(itemProvider.notifier);
    bool _isLoading = itemNotifier.isLoading;
    String errorMessage = itemNotifier.errorMessage;
    List<GroceryItem> groceryItems = ref.watch(itemProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NewItem()));
            },
          ),
        ],
      ),
      body: _isLoading // Check if data is loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != '' // Check if there is any error while loading data like network issue or something else
              ? Center(
                  child: Text(
                    'An error occured while loading data: '+errorMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              : groceryItems.length == 0 // Check if there are no grocery items
                  ? Center(
                      child: Text(
                        'Please add grocery items via clicking \'+\' icon.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: groceryItems.length,
                      itemBuilder: (context, index) {
                        return GroceryListItem(
                          groceryItem: groceryItems[index],
                          index: index + 1,
                        );
                      },
                    ),
    );
  }
}
