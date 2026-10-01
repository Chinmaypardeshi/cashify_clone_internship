import 'package:flutter/material.dart';
import 'condition_questionnaire_screen.dart';

class ModelSelectionScreen extends StatelessWidget {
  final String brandName;

  const ModelSelectionScreen({super.key, required this.brandName});

  // A basic hardcoded map to simulate a database query for models
  final Map<String, List<String>> _dummyModels = const {
    'Apple': ['iPhone 15 Pro Max', 'iPhone 15 Pro', 'iPhone 15', 'iPhone 14 Pro', 'iPhone 13'],
    'Samsung': ['Galaxy S24 Ultra', 'Galaxy S23', 'Galaxy Z Fold 5', 'Galaxy A54', 'Galaxy M53'],
    'OnePlus': ['OnePlus 12', 'OnePlus 11R', 'OnePlus Nord 3', 'OnePlus 10 Pro'],
  };

  @override
  Widget build(BuildContext context) {
    // Fetch the models for the selected brand, or default to generic models
    final models = _dummyModels[brandName] ?? ['Model 1', 'Model 2', 'Model 3'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Select $brandName Model'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: models.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final model = models[index];
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(model, style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConditionQuestionnaireScreen(modelName: model),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}