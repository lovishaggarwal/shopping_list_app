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
      body: groceryItems.length == 0
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
                return Dismissible(
                  key: Key(groceryItems[index].id),
                  onDismissed: (direction) {
                    itemNotifier.removeItem(groceryItems[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Grocery Item Deleted'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () {
                            itemNotifier.insertItem(index, groceryItems[index]);
                          },
                        ),
                      ),
                    );
                  },
                  child: GroceryListItem(
                    groceryItem: groceryItems[index],
                    index: index + 1,
                  ),
                );
              },
            ),
    );
  }
}
