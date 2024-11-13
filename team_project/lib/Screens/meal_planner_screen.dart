import 'package:flutter/material.dart';
import 'package:team_project/Services/api_services.dart'; // Import your ApiService

class MealPlannerScreen extends StatelessWidget {
  Color customGreen = Color.fromRGBO(20, 118, 21, 1.0);

  MealPlannerScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchMealPlan(diet: 'any'), // Call the API function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No meal plan available.'));
          } else {
            final mealPlan = snapshot.data!;

            // Assuming the API returns a list of meals or meal details
            final meals = mealPlan['meals'] ?? []; // Adjust this based on your API response

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Meal Plan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(meal['title'] ?? 'No title'),
                            subtitle: Text(meal['description'] ?? 'No description'),
                            trailing: Icon(Icons.add),
                            onTap: () {
                              // Action to add the meal to the planner or details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${meal['title']} to your plan'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new meal plan (could be a new screen or a dialog)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add a new meal plan')),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
