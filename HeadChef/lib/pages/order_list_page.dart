import 'package:flutter/material.dart';
import 'package:headchef/pages/add_new_order_page.dart';
import '../services/order_service.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrderService _orderService = OrderService();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      List<Map<String, dynamic>> orders = await _orderService.getAllOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void _navigateToAddOrder() async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderPage()),
    );
    if (shouldRefresh == true) {
      _fetchOrders(); // Fetch data again if new order was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddOrder,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green.shade900,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dish name', style: TextStyle(color: Colors.white)),
                Text('Notes', style: TextStyle(color: Colors.white)),
                Text('Quantity', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: _orders.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final dishName = order['dishName'] ?? 'Unknown Dish';
                final notes = order['notes'] ?? '';
                final quantity = order['quantity']?.toString() ?? '0';

                return Container(
                  color: Colors.green.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dishName, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('5 stars'),
                        ],
                      ),
                      Text(notes),
                      Text(quantity),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
