// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:team_project/services/api_services.dart'; // Import the API service
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For accessing the .env file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];  // List to hold recipe suggestions

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Search function that fetches recipes based on user input
  void _searchRecipe() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        // Fetching recipes from the API
        final apiService = ApiService();
        final recipes = await apiService.fetchRecipes(query);

        setState(() {
          _recipes = recipes;  // Storing the fetched recipes
        });
      } catch (error) {
        // Show error if fetching fails
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load recipes. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookify'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Explore Recipe'),
              Tab(text: "What's in Your Kitchen"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Explore Recipe tab with search bar and results
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Recipe...',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _searchRecipe,  // Trigger search on icon click
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _recipes.isEmpty
                          ? Center(child: Text('No recipes found. Try searching something else.'))
                          : ListView.builder(
                              itemCount: _recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = _recipes[index];
                                return ListTile(
                                  leading: recipe['image'] != null
                                      ? Image.network(recipe['image'], width: 50, height: 50)
                                      : null,
                                  title: Text(recipe['title']),
                                  subtitle: Text(recipe['readyInMinutes'] != null
                                      ? 'Ready in ${recipe['readyInMinutes']} minutes'
                                      : 'No time info'),
                                  onTap: () {
                                    // You can add more details or navigate to a detail page if needed
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
                // What's in Your Kitchen tab (Placeholder)
                Center(
                  child: Text('Ingredient-based suggestions here!'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
