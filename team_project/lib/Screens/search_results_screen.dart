import 'package:flutter/material.dart';
import 'package:team_project/Screens/recipe_details_screen.dart';
class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final List<dynamic> recipes;

  SearchResultsScreen({required this.searchQuery, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
        backgroundColor: Colors.green,
      ),
      body: recipes.isEmpty
          ? Center(child: Text('No results found for "$searchQuery"'))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  leading: recipe['image'] != null
                      ? Image.network(recipe['image'], width: 50, height: 50)
                      : null,
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['readyInMinutes'] != null
                      ? 'Ready in ${recipe['readyInMinutes']} minutes'
                      : 'No time info'),
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
    );
  }
}
