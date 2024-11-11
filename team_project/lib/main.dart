import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_project/Services/api_services.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final ApiService _apiService = ApiService();
  TextEditingController _controller = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  void _searchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final recipes = await _apiService.fetchRecipes(_controller.text);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewRecipeDetails(int id) async {
    final details = await _apiService.fetchRecipeDetails(id);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(details['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(details['image']),
              SizedBox(height: 10),
              Text('Ready in: ${details['readyInMinutes']} minutes'),
              SizedBox(height: 10),
              Text(details['instructions'] ?? 'No instructions available.'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search for a recipe',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchRecipes,
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              _recipes[index]['image'],
                              width: 50,
                              height: 50,
                            ),
                            title: Text(_recipes[index]['title']),
                            subtitle: Text(
                              'Ready in ${_recipes[index]['readyInMinutes']} minutes',
                            ),
                            onTap: () {
                              _viewRecipeDetails(_recipes[index]['id']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
