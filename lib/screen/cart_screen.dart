import 'package:flutter/material.dart';
import 'package:food_project/screen/order_complete_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(int) removeFromCart;

  CartScreen({required this.cart, required this.removeFromCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get subtotal => widget.cart
      .fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  void _increaseQuantity(int index) {
    setState(() {
      widget.cart[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] > 1) {
        widget.cart[index]['quantity']--;
      } else {
        widget.removeFromCart(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.cart[index]['image']),
                      radius: 30,
                    ),
                    title: Text(widget.cart[index]['name']),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _decreaseQuantity(index),
                        ),
                        Text(widget.cart[index]['quantity'].toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _increaseQuantity(index),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => widget.removeFromCart(index),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Subtotal"),
              trailing: Text("Rp. ${subtotal.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("PPN (10%)"),
              trailing: Text("Rp. ${tax.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("Total"),
              trailing: Text("Rp. ${total.toStringAsFixed(2)}"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double buttonWidth = constraints.maxWidth * 0.8; // 80% width
              double fontSize =
                  constraints.maxWidth < 350 ? 16 : 20; // Adjust font size

              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderCompleteScreen()));
                },
                child: Text("Checkout", style: TextStyle(fontSize: fontSize)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonWidth, 50),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
