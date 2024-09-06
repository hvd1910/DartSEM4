import 'dart:math';

import 'package:crudproduct2/models/productDTO.dart';
import 'package:flutter/material.dart';

import '../services/productService.dart';


class AddProductScreen extends StatefulWidget {
  final VoidCallback onProductAdded;

  AddProductScreen({required this.onProductAdded});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}


class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final ProductService productService = ProductService();

  void _addProduct() async {
     // Sinh ID với 10 ký tự

    final product = ProductDTO(
      // Gán ID ngẫu nhiên
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    await productService.createProduct(product);
    widget.onProductAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
