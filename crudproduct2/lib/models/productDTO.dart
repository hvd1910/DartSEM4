import 'dart:convert';

class ProductDTO {

  final String name;
  final String description;
  final double price;

  ProductDTO({
    required this.name,
    required this.description,
    required this.price,
  });

  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
