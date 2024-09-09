import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String dishName = '';
  String notes = '';
  int quantity = 1;
  final OrderService _orderService = OrderService();

  void _addItem() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      try {
        await _orderService.addOrder(dishName, 0, notes, quantity); // Assuming votes = 0 as default
        Navigator.pop(context, true); // Return to previous screen with a success flag
      } catch (e) {
        print('Error adding order: $e');
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      dishName = '';
      notes = '';
      quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dish name', style: TextStyle(color: Colors.blue[900])),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  dishName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dish name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Notes', style: TextStyle(color: Colors.blue[900])),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  notes = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              Text('Quantity', style: TextStyle(color: Colors.blue[900])),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onSaved: (value) {
                  quantity = int.tryParse(value ?? '1') ?? 1;
                },
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Add Item'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.green.shade700,
    );
  }
}
