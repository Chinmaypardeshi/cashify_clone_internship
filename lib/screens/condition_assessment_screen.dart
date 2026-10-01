import 'package:flutter/material.dart';
// Note: Replace this import with whatever your actual pricing/pickup screen is named
// import 'price_quote_screen.dart';

class ConditionAssessmentScreen extends StatefulWidget {
  final String category;
  final String brand;
  final String modelName;
  final int basePrice; // The perfect-condition price of the phone

  const ConditionAssessmentScreen({
    super.key,
    required this.category,
    required this.brand,
    required this.modelName,
    required this.basePrice,
  });

  @override
  State<ConditionAssessmentScreen> createState() => _ConditionAssessmentScreenState();
}

class _ConditionAssessmentScreenState extends State<ConditionAssessmentScreen> {
  // null means the user hasn't answered yet
  bool? _turnsOn;
  bool? _screenCracked;
  bool? _bodyDents;

  void _calculateAndProceed() {
    if (_turnsOn == null || _screenCracked == null || _bodyDents == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions to get a quote.')),
      );
      return;
    }

    double finalPrice = widget.basePrice.toDouble();

    // Apply deductions based on Cashify-style logic
    if (_turnsOn == false) {
      finalPrice = finalPrice * 0.30; // 70% deduction for dead device
    } else {
      if (_screenCracked == true) {
        finalPrice = finalPrice * 0.80; // 20% deduction for broken screen
      }
      if (_bodyDents == true) {
        finalPrice = finalPrice * 0.90; // 10% deduction for physical damage
      }
    }

    // TODO: Navigate to your existing Pickup/Quote screen here, passing the calculated finalPrice
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PriceQuoteScreen(
          modelName: widget.modelName,
          finalPrice: finalPrice.round(),
          conditionNotes: 'Turns on: $_turnsOn, Cracked: $_screenCracked, Dents: $_bodyDents',
        ),
      ),
    );
    */

    // Temporary popup to show you the math works before you link it
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Calculated Quote'),
          content: Text('Base Price: ₹${widget.basePrice}\nFinal Price: ₹${finalPrice.round()}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
          ],
        )
    );
  }

  Widget _buildQuestion(String question, bool? currentValue, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentValue == true ? Colors.teal : Colors.grey[200],
                      foregroundColor: currentValue == true ? Colors.white : Colors.black87,
                      elevation: 0,
                    ),
                    onPressed: () => setState(() => onChanged(true)),
                    child: const Text('Yes'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentValue == false ? Colors.teal : Colors.grey[200],
                      foregroundColor: currentValue == false ? Colors.white : Colors.black87,
                      elevation: 0,
                    ),
                    onPressed: () => setState(() => onChanged(false)),
                    child: const Text('No'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.modelName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your device',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Answer accurately to get the exact value at your doorstep.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildQuestion('Does the device turn on?', _turnsOn, (val) => _turnsOn = val),
            _buildQuestion('Is the screen cracked or broken?', _screenCracked, (val) => _screenCracked = val),
            _buildQuestion('Are there visible dents on the body?', _bodyDents, (val) => _bodyDents = val),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _calculateAndProceed,
                child: const Text('Get Exact Value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}