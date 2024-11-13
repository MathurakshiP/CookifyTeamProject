import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:team_project/providers/saved_food_provider.dart';
import 'package:team_project/screens/recipe_details_screen.dart'; // Import RecipeDetailScreen

class SavedFoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final savedFoodProvider = Provider.of<SavedFoodProvider>(context);
    final savedRecipes = savedFoodProvider.savedRecipes;
    Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
        backgroundColor: customGreen,
        automaticallyImplyLeading: false,
      ),
      body: savedRecipes.isNotEmpty
          ? ListView.builder(
              itemCount: savedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = savedRecipes[index];
                return ListTile(
                  leading: recipe['image'] != null
                      ? Image.network(recipe['image'], width: 50, height: 50)
                      : null,
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['readyInMinutes'] != null
                      ? 'Ready in ${recipe['readyInMinutes']} minutes'
                      : 'No time info'),
                  onTap: () {
                    // Navigate to RecipeDetailScreen when a recipe is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipeId: recipe['id']),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text('No saved recipes yet!'),
            ),
    );
  }
}
