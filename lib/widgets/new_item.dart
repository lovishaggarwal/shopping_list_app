import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppingListApp/data/categories.dart';
import 'package:shoppingListApp/models/category.dart';
import 'package:shoppingListApp/models/grocery_item.dart';
import 'package:shoppingListApp/providers/item_provider.dart';

class NewItem extends ConsumerWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    String? itemName;
    int? quantity;
    Category? itemCategory;

    void saveItem() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        DateTime now = DateTime.now();
        String id = now.millisecondsSinceEpoch.toString();
        print(id);
        ref.read(itemProvider.notifier).addItem(GroceryItem(
            id: id,
            name: itemName!,
            quantity: quantity!,
            category: itemCategory!));
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
                validator: (value) =>
                    (value == null || value.isEmpty || value.trim().length <= 1)
                        ? 'Please enter a name'
                        : null,
                onSaved: (newValue) => itemName = newValue,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '0',
                      validator: (value) => (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0)
                          ? 'Please enter a valid quantity'
                          : null,
                      onSaved: (newValue) => quantity = int.tryParse(newValue!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: DropdownButtonFormField(
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: [
                        for (var category in categories.values)
                          DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: category.color,
                                  radius: 8,
                                ),
                                const SizedBox(width: 8),
                                Text(category.title),
                              ],
                            ),
                          ),
                      ],
                      onSaved: (value) => itemCategory = value as Category,
                      onChanged: (Category? value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
