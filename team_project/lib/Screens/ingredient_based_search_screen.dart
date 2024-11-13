// lib/screens/ingredient_search_screen.dart
import 'package:flutter/material.dart';
import 'package:team_project/Services/api_services.dart';
import 'package:team_project/Screens/recipe_details_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';  

class IngredientSearchScreen extends StatefulWidget {
  @override
  _IngredientSearchScreenState createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  List<dynamic> _recipes = [];
  Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);

  void _searchByIngredients() async {
    final ingredients = _ingredientController.text
        .split(',')
        .map((ingredient) => ingredient.trim()) // Trim spaces around ingredients
        .toList();

    if (ingredients.isNotEmpty) {
      try {
        final apiService = ApiService();
        final recipes = await apiService.fetchRecipesByIngredients(ingredients);
        setState(() {
          _recipes = recipes;
        });
      } catch (error) {
        print('Error: $error');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (comma-separated)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchByIngredients,
                ),
              ),
            ),
          ),
          Expanded(
            child: _recipes.isEmpty
                ? Center(child: Text('No recipes found.'))
                : ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return ListTile(
                        leading: recipe['image'] != null
                            ? Image.network(recipe['image'], width: 50, height: 50)
                            : null,
                        title: Text(recipe['title']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipeId: recipe['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



