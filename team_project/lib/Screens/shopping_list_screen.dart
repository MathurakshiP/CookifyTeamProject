import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/providers/shopping_list_provider.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access shopping list from the provider
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final shoppingList = shoppingListProvider.shoppingList;
    Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        backgroundColor: customGreen,
        automaticallyImplyLeading: false, // Prevents the back arrow from appearing
      ),
      body: shoppingList.isNotEmpty
          ? ListView.builder(
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                final item = shoppingList[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      shoppingListProvider.removeItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$item removed from shopping list')),
                      );
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('No items in your shopping list!'),
            ),
    );
  }
}
