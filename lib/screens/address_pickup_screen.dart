import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class AddressPickupScreen extends StatefulWidget {
  final String modelName;
  final int agreedPrice;

  const AddressPickupScreen({
    super.key,
    required this.modelName,
    required this.agreedPrice,
  });

  @override
  State<AddressPickupScreen> createState() => _AddressPickupScreenState();
}

class _AddressPickupScreenState extends State<AddressPickupScreen> {
  // Controllers to capture user text input
  final _flatController = TextEditingController();
  final _streetController = TextEditingController();

  bool _isSaving = false;
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

  final List<String> _dates = ['Tomorrow', 'Day After', 'In 3 Days'];
  final List<String> _times = ['09 AM - 01 PM', '02 PM - 05 PM', '06 PM - 09 PM'];

  @override
  void dispose() {
    _flatController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    // Basic validation
    if (_flatController.text.trim().isEmpty || _streetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your complete address')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get the currently logged-in user
      final user = FirebaseAuth.instance.currentUser;

      // Save the order to Firestore NoSQL database
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user?.uid ?? 'guest_user',
        'modelName': widget.modelName,
        'agreedPrice': widget.agreedPrice,
        'flatOrBuilding': _flatController.text.trim(),
        'streetLocality': _streetController.text.trim(),
        'pickupDate': _dates[_selectedDateIndex],
        'pickupTime': _times[_selectedTimeIndex],
        'status': 'Pending Pickup',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(32),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 24),
                const Text('Pickup Scheduled!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  'Our executive will arrive at your address to inspect the ${widget.modelName} and pay you ₹${widget.agreedPrice}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                      );
                    },
                    child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Schedule Pickup'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pickup Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _flatController,
              decoration: InputDecoration(
                labelText: 'Flat / House No / Floor / Building',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _streetController,
              decoration: InputDecoration(
                labelText: 'Street / Locality',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),

            const Text('Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: List.generate(_dates.length, (index) {
                return ChoiceChip(
                  label: Text(_dates[index]),
                  selected: _selectedDateIndex == index,
                  selectedColor: Colors.teal.withValues(alpha: 0.2),
                  onSelected: (selected) => setState(() => _selectedDateIndex = index),
                );
              }),
            ),
            const SizedBox(height: 32),

            const Text('Select Time Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_times.length, (index) {
                return ChoiceChip(
                  label: Text(_times[index]),
                  selected: _selectedTimeIndex == index,
                  selectedColor: Colors.teal.withValues(alpha: 0.2),
                  onSelected: (selected) => setState(() => _selectedTimeIndex = index),
                );
              }),
            ),
          ],
        ),
      ),
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
            onPressed: _isSaving ? null : _confirmOrder,
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Confirm Pickup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}