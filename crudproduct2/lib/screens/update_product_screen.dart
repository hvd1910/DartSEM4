import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/productService.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onProductUpdated;

  UpdateProductScreen({required this.product, required this.onProductUpdated});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.product.id);
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  void _updateProduct() async {
    final updatedProduct = Product(
      id: _idController.text,
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    await productService.updateProduct(widget.product.id, updatedProduct);
    widget.onProductUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              readOnly: true, // Không cho phép chỉnh sửa ID
              decoration: InputDecoration(labelText: 'ID'),
            ),
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
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
