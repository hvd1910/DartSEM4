import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả đơn hàng
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('headchef').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  // Thêm đơn hàng mới
  Future<void> addOrder(String dishName, int votes, String notes, int quantity) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('headchef').add({
        'dishName': dishName,
        'votes': 5,
        'notes': notes,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(), // Adds the creation time
      });
      print('Order added successfully!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

}
