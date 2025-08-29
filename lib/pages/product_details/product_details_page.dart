// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myntra/Home/tab_bar.dart';
import 'package:myntra/models/CategoryModel.dart';
import 'package:myntra/pages/product_details/add_to_cart.dart';
import 'package:myntra/pages/product_details/buynow.dart';
import 'package:myntra/classes/button.dart';
import 'package:myntra/pages/product_details/cart_model.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final CategoryItem item;

  const ProductDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int imageCurrentIndex = 0;
  String? selectedSize;
  bool showSizeError = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Check if selected size product is already in cart
    final bool isInCart =
        selectedSize != null &&
        context.select<CartModel, bool>(
          (cart) => cart.items.any(
            (cartItem) =>
                cartItem.item == widget.item && cartItem.size == selectedSize,
          ),
        );

    return TopNavScaffold(
      logo: SvgPicture.asset('assets/images/meeshoLogo.svg', height: 40),
      categories: [
        "Women Ethnic",
        "Men",
        "Kids",
        "Beauty & Health",
        "Home & Kitchen",
        "Electronics",
      ],
      pages: [
        Center(child: Text("Women Ethnic Page")),
        Center(child: Text("Men Page")),
        Center(child: Text("Kids Page")),
        Center(child: Text("Beauty Page")),
        Center(child: Text("Home Page")),
        Center(child: Text("Electronics Page")),
      ],
      customBody: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 800;

                return isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _mainImageSection(screenWidth, isMobile),
                          const SizedBox(height: 15),

                          // ✅ Buttons placed just below the main image
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: [
                              CommonButton.myButton(
                                context,
                                isMobile ? screenWidth * 0.8 : 150,
                                10,
                                15,
                                10,
                                15,
                                () {
                                  if (isInCart) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AddToCart(),
                                      ),
                                    );
                                  } else {
                                    if (selectedSize == null) {
                                      setState(() => showSizeError = true);
                                    } else {
                                      Provider.of<CartModel>(
                                        context,
                                        listen: false,
                                      ).addItem(widget.item, selectedSize!, 1);
                                    }
                                  }
                                },
                                isInCart ? "Go To Cart" : "Add to Cart",
                                icon: isInCart
                                    ? Icons.shopping_cart
                                    : Icons.add_shopping_cart,
                              ),
                              CommonButton.filledButton(
                                context,
                                isMobile ? screenWidth * 0.8 : 150,
                                10,
                                15,
                                10,
                                15,
                                () {
                                  if (selectedSize == null) {
                                    setState(() => showSizeError = true);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BuyNowPage(item: widget.item),
                                      ),
                                    );
                                  }
                                },
                                "Buy Now",
                                icon: Icons.keyboard_arrow_right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _thumbnailSection(isMobile),
                          const SizedBox(height: 15),
                          _productDetailsSection(isMobile, constraints),
                          const SizedBox(height: 15),
                          _sizeSelectorSection(isMobile, constraints),
                          const SizedBox(height: 15),
                          _fullDetailsSection(isMobile, constraints),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: _thumbnailSection(isMobile)),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _mainImageSection(screenWidth, isMobile),
                                const SizedBox(height: 15),

                                // ✅ Buttons just below image on desktop
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    CommonButton.myButton(
                                      context,
                                      isMobile ? screenWidth * 0.8 : 150,
                                      10,
                                      15,
                                      10,
                                      15,
                                      () {
                                        if (isInCart) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const AddToCart(),
                                            ),
                                          );
                                        } else {
                                          if (selectedSize == null) {
                                            setState(
                                              () => showSizeError = true,
                                            );
                                          } else {
                                            Provider.of<CartModel>(
                                              context,
                                              listen: false,
                                            ).addItem(
                                              widget.item,
                                              selectedSize!,
                                              1,
                                            );
                                          }
                                        }
                                      },
                                      isInCart ? "Go To Cart" : "Add to Cart",
                                      icon: isInCart
                                          ? Icons.shopping_cart
                                          : Icons.add_shopping_cart,
                                    ),
                                    CommonButton.filledButton(
                                      context,
                                      isMobile ? screenWidth * 0.8 : 150,
                                      10,
                                      15,
                                      10,
                                      15,
                                      () {
                                        if (selectedSize == null) {
                                          setState(() => showSizeError = true);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BuyNowPage(item: widget.item),
                                            ),
                                          );
                                        }
                                      },
                                      "Buy Now",
                                      icon: Icons.keyboard_arrow_right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _productDetailsSection(isMobile, constraints),
                                const SizedBox(height: 15),
                                _sizeSelectorSection(isMobile, constraints),
                                const SizedBox(height: 15),
                                _fullDetailsSection(isMobile, constraints),
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// MAIN IMAGE SECTION
  Widget _mainImageSection(double screenWidth, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: screenWidth < 800 ? screenWidth * 0.7 : 450,
          width: screenWidth < 800 ? screenWidth * 0.9 : 500,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black, width: 0.25),
            ),
            color: Colors.white10,
          ),
          child:
              widget.item.productImages.isNotEmpty &&
                  imageCurrentIndex < widget.item.productImages.length
              ? Image.network(
                  widget.item.productImages[imageCurrentIndex],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 150),
                )
              : const Icon(Icons.image_not_supported, size: 150),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _thumbnailSection(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        direction: isMobile ? Axis.horizontal : Axis.vertical,
        children: widget.item.productImages.asMap().entries.map((entry) {
          int index = entry.key;
          String imageUrl = entry.value;
          return InkWell(
            onTap: () => setState(() => imageCurrentIndex = index),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: imageCurrentIndex == index
                      ? Colors.blueAccent
                      : Colors.black12,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// PRODUCT DETAILS SECTION
  Widget _productDetailsSection(bool isMobile, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(width: 0.25),
        ),
        color: Colors.white10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.name,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(185, 123, 127, 129),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '₹${widget.item.price}',
            style: const TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item.averageRatingStr,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 16, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('${widget.item.ratingCount} Ratings'),
              const SizedBox(width: 10),
              Text('${widget.item.reviewCount} Reviews'),
            ],
          ),
        ],
      ),
    );
  }

  /// SIZE SELECTOR SECTION
  Widget _sizeSelectorSection(bool isMobile, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(width: 0.25),
        ),
        color: Colors.white10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Size",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ["S", "M", "L", "XL", "XXL"].map((size) {
              return CommonButton.mcButton(
                context,
                60,
                10,
                15,
                10,
                15,
                () {
                  setState(() {
                    if (selectedSize == size) {
                      selectedSize = null;
                    } else {
                      selectedSize = size;
                      showSizeError = false;
                    }
                  });
                },
                size,
                isSelected: selectedSize == size,
              );
            }).toList(),
          ),
          if (showSizeError)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Please select a size",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  /// FULL DETAILS SECTION
  Widget _fullDetailsSection(bool isMobile, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(width: 0.25),
        ),
        color: Colors.white10,
      ),
      child: Text(
        widget.item.fullDetails,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 143, 159, 167),
        ),
      ),
    );
  }
}
