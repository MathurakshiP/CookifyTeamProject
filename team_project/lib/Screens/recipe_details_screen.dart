// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:team_project/Services/api_services.dart';
import 'package:team_project/providers/saved_food_provider.dart';
import 'package:team_project/providers/shopping_list_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  RecipeDetailScreen({required this.recipeId});
  Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchRecipeDetails(recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipe = snapshot.data!;
            final savedFoodProvider = Provider.of<SavedFoodProvider>(context);
            final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

            // Check if the recipe is already saved
            bool isSaved = savedFoodProvider.savedRecipes
                .any((savedRecipe) => savedRecipe['id'] == recipeId);

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                if (recipe['image'] != null)
                  Image.network(recipe['image'], height: 200, fit: BoxFit.cover),
                SizedBox(height: 16),
                Text(recipe['title'], style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text('Cooking Time: ${recipe['readyInMinutes']} minutes'),
                SizedBox(height: 16),
                // Buttons for saving the recipe and adding ingredients to the shopping list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: isSaved ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        // Toggle saved state
                        if (isSaved) {
                          savedFoodProvider.removeRecipe(recipe);
                        } else {
                          savedFoodProvider.addRecipe(recipe);
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final ingredients = recipe['extendedIngredients']?.map((i) => i['original'].toString()).toList() ?? [];

                        // Log the ingredients to verify
                        print('Adding ingredients to shopping list: $ingredients');

                        shoppingListProvider.addItems(ingredients);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ingredients added to shopping list!')),
                        );
                      },
                      child: Text('Add to Shopping List'),
                    ),

                  ],
                ),
                SizedBox(height: 16),
                Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...List.generate(recipe['extendedIngredients']?.length ?? 0, (index) {
                  return Text('- ${recipe['extendedIngredients'][index]['original']}');
                }),
                SizedBox(height: 16),
                Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(recipe['instructions'] ?? 'No instructions available.'),
              ],
            );
          }
        },
      ),
    );
  }
}
