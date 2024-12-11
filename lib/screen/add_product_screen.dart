import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  final Function(String, String, double, String) addProduct;

  AddProductScreen({required this.addProduct});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Submit form and validate fields
  void _submitForm() {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      widget.addProduct(
        _nameController.text,
        _image?.path ?? 'asset/images/default.png', // Use default image if none selected
        double.parse(_priceController.text),
        _categoryController.text,
      );
      Navigator.pop(context); // Close screen after adding product
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Product Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            
            // Price Field
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 10),
            
            // Category Field
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            
            // Display selected image or message if none
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 10),
            
            // Button to pick image
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            Spacer(),
            
            // Submit button to add product
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
