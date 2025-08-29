// ignore_for_file: avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:myntra/pages/product_details/buynow.dart';
import 'package:provider/provider.dart';
import 'package:myntra/pages/product_details/cart_model.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    print("Number of items in cart: ${cart.items.length}");

    final items = cart.items;
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text("Your cart is empty", style: TextStyle(fontSize: 18)),
            )
          : isMobile
          ? Column(
              children: [
                Expanded(child: _buildCartList(items, context)),
                _buildPriceDetails(context, cart, isMobile),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left - Cart Items
                Expanded(flex: 2, child: _buildCartList(items, context)),
                // Right - Price Details
                Container(
                  width: 450,
                  child: _buildPriceDetails(context, cart, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildCartList(List<CartItem> items, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cartItem = items[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.item.productImages.isNotEmpty
                      ? cartItem.item.productImages[0]
                      : "",
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(width: 12),
              // Product info and actions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name and EDIT button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cartItem.item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "EDIT",
                          style: TextStyle(
                            color: Color.fromARGB(255, 158, 5, 91),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      "₹${cartItem.item.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Return and other info
                    const Text(
                      "All issue easy returns",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    // Size and quantity info with bullet point
                    Text(
                      "Size: ${cartItem.size}  •  Qty: ${cartItem.quantity}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // REMOVE button with X icon
                    GestureDetector(
                      onTap: () =>
                          context.read<CartModel>().removeItem(cartItem),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.close, size: 18, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "REMOVE",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Seller info
                    Divider(thickness: 0.25, color: Colors.black),
                    const Text(
                      "Sold by: SAVANI TEXTILE INDUSTRIES PRIVATE LIMITED  Free Delivery",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceDetails(
    BuildContext context,
    CartModel cart,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border(
          top: isMobile
              ? const BorderSide(color: Colors.grey, width: 0.5)
              : BorderSide.none,
          left: !isMobile
              ? const BorderSide(color: Colors.grey, width: 0.5)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price Details (${cart.items.length} Items)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Product Price"),
              Text(
                "₹${cart.totalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Order Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "₹${cart.totalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Proceed to Checkout")),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BuyNowPage(item: cart.items.first.item),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
                backgroundColor: const Color.fromARGB(255, 187, 14, 196),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Clicking on 'Continue' will not deduct any money",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/me1.png', // Replace with your image file name
                  width: 400, // Optional: set width
                  height: 150, // Optional: set height
                  fit: BoxFit.contain, // Optional: control how the image fits
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
