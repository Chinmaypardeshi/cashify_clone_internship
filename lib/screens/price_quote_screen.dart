import 'package:flutter/material.dart';
import 'address_pickup_screen.dart';

class PriceQuoteScreen extends StatelessWidget {
  final String modelName;
  final bool turnsOn;
  final bool screenIntact;
  final bool bodyIntact;
  final bool hasOriginalCharger;

  const PriceQuoteScreen({
    super.key,
    required this.modelName,
    required this.turnsOn,
    required this.screenIntact,
    required this.bodyIntact,
    required this.hasOriginalCharger,
  });

  // Dummy logic to calculate a dynamic price based on the brand/model and conditions
  int _calculateFinalPrice() {
    int basePrice = 15000; // Default base price

    if (modelName.contains('iPhone')) {
      basePrice = 45000;
    } else if (modelName.contains('Galaxy S') || modelName.contains('Fold')) {
      basePrice = 35000;
    } else if (modelName.contains('OnePlus 12')) {
      basePrice = 28000;
    }

    // Apply deductions based on condition
    if (!turnsOn) {
      return (basePrice * 0.15).toInt(); // Severe penalty for a dead phone
    }

    if (!screenIntact) basePrice -= 5000;
    if (!bodyIntact) basePrice -= 2500;
    if (!hasOriginalCharger) basePrice -= 1000;

    // Ensure the price doesn't drop below a minimum salvage value
    return basePrice > 1000 ? basePrice : 1000;
  }

  @override
  Widget build(BuildContext context) {
    final finalPrice = _calculateFinalPrice();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Your Price Quote'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Best Value Guaranteed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                modelName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 32),

              // Quote Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Estimated Selling Price', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),
                    Text(
                      '₹$finalPrice',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.teal),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(turnsOn ? Icons.check_circle : Icons.error, color: turnsOn ? Colors.green : Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(turnsOn ? 'Device turns on' : 'Does not turn on', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(screenIntact ? Icons.check_circle : Icons.warning, color: screenIntact ? Colors.green : Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(screenIntact ? 'Flawless Screen' : 'Screen Damaged', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressPickupScreen(
                          modelName: modelName, // Pass the model name here
                          agreedPrice: finalPrice,
                        ),
                      ),
                    );
                  },
                  child: const Text('Schedule Pickup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}