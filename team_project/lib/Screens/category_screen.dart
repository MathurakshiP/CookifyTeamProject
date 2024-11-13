import 'package:flutter/material.dart';
import 'package:team_project/services/api_services.dart'; // Assuming ApiService fetches recipes based on category
import 'package:team_project/screens/recipe_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic> _categoryRecipes = [];
  bool _isLoading = false;
  Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);
  @override
  void initState() {
    super.initState();
    _fetchCategoryRecipes();
  }

  // Fetch recipes based on the selected category (Breakfast, Lunch, Dinner, Dessert)
  void _fetchCategoryRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await ApiService().fetchRecipesByCategory(widget.category);
      setState(() {
        _categoryRecipes = recipes;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching recipes for category ${widget.category}: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load recipes. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: customGreen,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _categoryRecipes.isEmpty
              ? Center(child: Text('No recipes available for ${widget.category}.'))
              : ListView.builder(
                  itemCount: _categoryRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _categoryRecipes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(recipeId: recipe['id']),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            recipe['image'] != null
                                ? Image.network(
                                    recipe['image'],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image, size: 150);
                                    },
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey,
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe['title'] ?? 'No Title',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
