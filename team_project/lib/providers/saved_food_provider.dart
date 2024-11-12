// providers/saved_food_provider.dart
import 'package:flutter/material.dart';

class SavedFoodProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _savedRecipes = [];

  List<Map<String, dynamic>> get savedRecipes => _savedRecipes;

  void addRecipe(Map<String, dynamic> recipe) {
    _savedRecipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(Map<String, dynamic> recipe) {
    _savedRecipes.remove(recipe);
    notifyListeners();
  }
}
