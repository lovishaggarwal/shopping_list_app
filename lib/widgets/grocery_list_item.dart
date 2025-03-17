import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppingListApp/models/grocery_item.dart';
import 'package:shoppingListApp/providers/item_provider.dart';

class GroceryListItem extends ConsumerWidget {
  const GroceryListItem(
      {super.key, required this.groceryItem, required this.index});

  final int index;
  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool undoClicked = false;
    final itemNotifier = ref.read(itemProvider.notifier);

    void deleteItem() {
      itemNotifier.removeItem(groceryItem);
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text('Grocery Item Deleted'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    undoClicked = true;
                    itemNotifier.insertItem(index-1, groceryItem);
                  },
                ),
              ),
            )
            .closed
            .then((reason) {
              if (!undoClicked)
                itemNotifier.removeFromFirebase(groceryItem);
        });
    }

    return Dismissible(
      key: Key(groceryItem.id),
      onDismissed: (direction) {
        deleteItem();
      },
      child: ListTile(
        title: Text(groceryItem.name),
        subtitle: Text('Quantity: ${groceryItem.quantity}'),
        leading: CircleAvatar(
          backgroundColor: groceryItem.category.color,
          child: Text(
            index.toString(),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Colors.black),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteItem();
          },
        ),
      ),
    );
  }
}
