import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'screen/cart_screen.dart';
import 'screen/add_product_screen.dart';

void main() {
  runApp(FoodMarketApp());
}

class FoodMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodMarketApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String selectedCategory = 'All';
  List<Map<String, dynamic>> cart = [];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'image': 'asset/images/burger.jpeg'},
    {'name': 'Makanan', 'image': 'asset/images/burger.jpeg'},
    {'name': 'Minuman', 'image': 'asset/images/teh botol.jpeg'},
  ];

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Burger King Medium',
      'image': 'asset/images/burger.jpeg',
      'price': 50000,
      'category': 'Makanan',
    },
    {
      'name': 'Teh Botol',
      'image': 'asset/images/teh botol.jpeg',
      'price': 4000,
      'category': 'Minuman',
    },
    {
      'name': 'Burger King Small',
      'image': 'asset/images/burger.jpeg',
      'price': 35000,
      'category': 'Makanan',
    },
  ];

  late List<Map<String, dynamic>> displayedProducts;

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(allProducts);
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        displayedProducts = List.from(allProducts);
      } else {
        displayedProducts = allProducts
            .where((product) => product['category'] == category)
            .toList();
      }
    });
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      final index = cart.indexWhere((item) => item['name'] == product['name']);
      if (index != -1) {
        cart[index]['quantity'] += 1;
      } else {
        cart.add({...product, 'quantity': 1});
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void addNewMenuItem(
      String name, String image, double price, String category) {
    setState(() {
      allProducts.add({
        'name': name,
        'image': image,
        'price': price,
        'category': category,
      });
      if (selectedCategory == 'All' || selectedCategory == category) {
        displayedProducts = List.from(allProducts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _views = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return _categoryButton(category['name'], category['image']);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 5,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                final cartItemIndex =
                    cart.indexWhere((item) => item['name'] == product['name']);
                final cartQuantity =
                    cartItemIndex != -1 ? cart[cartItemIndex]['quantity'] : 0;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          product['image'],
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp. ${product['price'].toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: cartQuantity > 0
                                  ? () {
                                      setState(() {
                                        cart[cartItemIndex]['quantity']--;
                                        if (cart[cartItemIndex]['quantity'] == 0) {
                                          cart.removeAt(cartItemIndex);
                                        }
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              cartQuantity.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (cartItemIndex != -1) {
                                    cart[cartItemIndex]['quantity']++;
                                  } else {
                                    cart.add({...product, 'quantity': 1});
                                  }
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      CartScreen(cart: cart, removeFromCart: removeFromCart),
      AddProductScreen(addProduct: addNewMenuItem),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('FoodMarketApp'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Add Menu',
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String label, String imagePath) {
    return GestureDetector(
      onTap: () => filterProducts(label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedCategory == label
              ? Colors.blue.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selectedCategory == label ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selectedCategory == label ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
