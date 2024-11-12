import 'package:flutter/material.dart';
import 'package:team_project/Screens/meal_planner_screen.dart';
import 'package:team_project/screens/category_screen.dart';
import 'package:team_project/screens/saved_food_screen.dart';
import 'package:team_project/screens/shopping_list_screen.dart';
import 'package:team_project/screens/profile_screen.dart';  // Placeholder for Profile screen
import 'package:team_project/services/api_services.dart';
import 'package:team_project/screens/recipe_details_screen.dart';
import 'package:team_project/screens/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  List<dynamic> _randomRecipes = [];
  List<dynamic> _savedRecipes = []; // List to hold saved recipes
  List<dynamic> _shoppingList = [];
  bool _isLoading = false; // To handle loading state for random recipes
  int _selectedIndex = 0; // For bottom navigation bar
  List<dynamic> _recentlyViewed = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRandomRecipes(); // Load random recipes on init
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch random recipes for "Latest Recipes" section
  void _loadRandomRecipes() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final randomRecipes = await ApiService().fetchRandomRecipes(number: 5);
      setState(() {
        _randomRecipes = randomRecipes;
        _isLoading = false; // Stop loading once data is fetched
      });
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading in case of error
      });
      print('Error fetching random recipes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load random recipes. Please try again later.')),
      );
    }
  }

  // Search function that fetches recipes based on user input
  void _searchRecipe() async {
    final query = _searchController.text;

    if (query.isNotEmpty) {
      try {
        final apiService = ApiService();
        final recipes = await apiService.fetchRecipes(query);

        setState(() {
          _recipes = recipes;
          _recentlyViewed= recipes;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultsScreen(searchQuery: query, recipes: _recipes),
          ),
        );
      } catch (error) {
        print('Error: $error');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load recipes. Please try again.')),
        );
      }
    }
  }

  // Bottom navigation bar action
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // To show different app bar based on the current screen
  PreferredSizeWidget _buildAppBar() {
    if (_selectedIndex == 0) {
      // Home Screen AppBar
      return AppBar(
        title: Row(
          children: [
            Text('Cookify'), // Top left title
          ],
        ),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today), // Meal plan icon
            onPressed: () {
              // Navigate to meal plan screen or action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealPlannerScreen()),
              );
            },
          ),
        ],
      );
    } else {
      // Other Screens (do not show app bar)
      return PreferredSize(preferredSize: Size(0, 0), child: Container());
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),  // Use custom app bar method
    body: IndexedStack(
      index: _selectedIndex,
      children: [
        // Home Screen Content
        SingleChildScrollView(  // Added scrollable functionality
          child: Column(
            children: [
              // Tab Navigation for Explore Recipe and What's in Your Kitchen
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Explore Recipe'),
                  Tab(text: "What's in Your Kitchen"),
                ],
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Recipe...',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchRecipe,
                    ),
                  ),
                ),
              ),
              
              // Horizontal tabs for meal categories
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMealCategoryTab('Breakfast'),
                      _buildMealCategoryTab('Lunch'),
                      _buildMealCategoryTab('Dinner'),
                      _buildMealCategoryTab('Dessert'),
                    ],
                  ),
                ),
              ),

              // Latest Recipes Section (Horizontally Scrollable)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Latest Recipes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              _isLoading
                  ? CircularProgressIndicator() // Show loading indicator while fetching data
                  : Container(
                      height: 250, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _randomRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _randomRecipes[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the recipe details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 250, // Fixed width for the card
                              child: Card(
                                margin: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image handling
                                    recipe['image'] != null
                                        ? Image.network(
                                            recipe['image'],
                                            height: 120,
                                            width: 250,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(Icons.broken_image, size: 120); // Show icon if image is broken
                                            },
                                          )
                                        : Container(
                                            height: 120,
                                            width: 120,
                                            color: Colors.grey, // Default placeholder color if no image
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        recipe['title'] ?? 'No Title', // Display title or fallback text
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

              // Recently Viewed Foods Section
// Recently Viewed Foods Section
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(
    'Recently Viewed Foods',
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
),
_recentlyViewed.isEmpty
    ? Center(child: Text('No recently viewed foods'))
    : Container(
        height: 250, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recentlyViewed.length,
          itemBuilder: (context, index) {
            final recipe = _recentlyViewed[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the recipe details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                  ),
                );
              },
              child: SizedBox(
                width: 250, // Fixed width for the card
                child: Card(
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image handling
                      recipe['image'] != null
                          ? Image.network(
                              recipe['image'],
                              height: 120,
                              width: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 120); // Show icon if image is broken
                              },
                            )
                          : Container(
                              height: 120,
                              width: 250, // Ensuring image container is fixed size
                              color: Colors.grey, // Default placeholder color if no image
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          recipe['title'] ?? 'No Title', // Display title or fallback text
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),




            ],
          ),
        ),
        SavedFoodScreen(),
          // ShoppingListScreen with passed shoppingList
          ShoppingListScreen(),
          // ProfileScreen
          ProfileScreen(),
      ],
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shopping List'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
    ),
  );
}

  Widget _buildMealCategoryTab(String category) {
    return GestureDetector(
      onTap: () {
        // Navigate to the category screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
