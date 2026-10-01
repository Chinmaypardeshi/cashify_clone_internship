import 'package:flutter/material.dart';
import 'price_quote_screen.dart';

class ConditionQuestionnaireScreen extends StatefulWidget {
  final String modelName;

  const ConditionQuestionnaireScreen({super.key, required this.modelName});

  @override
  State<ConditionQuestionnaireScreen> createState() => _ConditionQuestionnaireScreenState();
}

class _ConditionQuestionnaireScreenState extends State<ConditionQuestionnaireScreen> {
  // Default states for the device condition checklist
  bool _turnsOn = true;
  bool _screenIntact = true;
  bool _bodyIntact = true;
  bool _hasOriginalCharger = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Device Condition'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.white,
            child: Text(
              'Evaluating: ${widget.modelName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildConditionToggle(
                  'Does the device turn on?',
                  'Device must power on and reach the home screen.',
                  _turnsOn,
                      (val) => setState(() => _turnsOn = val),
                ),
                _buildConditionToggle(
                  'Is the screen intact?',
                  'No cracks, scratches, or discoloration on the display.',
                  _screenIntact,
                      (val) => setState(() => _screenIntact = val),
                ),
                _buildConditionToggle(
                  'Is the body free of dents?',
                  'No major dents or bends on the side or back panel.',
                  _bodyIntact,
                      (val) => setState(() => _bodyIntact = val),
                ),
                _buildConditionToggle(
                  'Do you have the original charger?',
                  'Original charging brick and cable included.',
                  _hasOriginalCharger,
                      (val) => setState(() => _hasOriginalCharger = val),
                ),
              ],
            ),
          ),
        ],
      ),
      // Fixed bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PriceQuoteScreen(
                    modelName: widget.modelName,
                    turnsOn: _turnsOn,
                    screenIntact: _screenIntact,
                    bodyIntact: _bodyIntact,
                    hasOriginalCharger: _hasOriginalCharger,
                  ),
                ),
              );
            },
            child: const Text('Get Price Quote', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        value: value,
        // FIXED: Replaced activeColor with modern properties
        activeThumbColor: Colors.teal,
        activeTrackColor: Colors.teal.withValues(alpha: 0.3),
        onChanged: onChanged,
      ),
    );
  }
}