// ignore_for_file: use_super_parameters, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:myntra/classes/button.dart';
import 'package:myntra/models/CategoryModel.dart';

class BuyNowPage extends StatefulWidget {
  final CategoryItem item;

  BuyNowPage({Key? key, required this.item}) : super(key: key);

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buy Now - ${widget.item.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.item.imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.item.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ₹${widget.item.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${widget.item.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CommonButton.myButton(context, double.infinity, 10, 15, 10, 15, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Purchased ${widget.item.name}!')),
              );
            }, "CONFIRM PURCHASE"),
          ],
        ),
      ),
    );
  }
}
