// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:myntra/pages/product_details/add_to_cart.dart';
import 'package:myntra/pages/product_details/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopNavScaffold extends StatefulWidget {
  final Widget logo;
  final List<String> categories;
  final List<Widget> pages;
  final Widget? customBody;
  final int initialTabIndex; // ✅ New parameter

  const TopNavScaffold({
    Key? key,
    required this.logo,
    required this.categories,
    required this.pages,
    this.customBody,
    this.initialTabIndex = 0, // default 0
  }) : super(key: key);

  @override
  _TopNavScaffoldState createState() => _TopNavScaffoldState();
}

class _TopNavScaffoldState extends State<TopNavScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
      initialIndex: widget.initialTabIndex, // ✅ Use initialTabIndex
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _saveLastTab(_tabController.index);
      }
    });
  }

  Future<void> _saveLastTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTab', index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final int cartCount = cart.cartCount;

    bool canGoBack = Navigator.of(context).canPop();
    print("pavan debug canpop: $canGoBack ");

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Navigation Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                if (canGoBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                else
                  widget.logo,
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Try Saree, Kurti or Search by Product Code",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.purple),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Become a Supplier",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.person_outline, size: 28),
                const SizedBox(width: 10),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddToCart()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Category Tabs
          Container(
            height: 50,
            color: Colors.grey[100],
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.purple,
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.black87,
              tabs: widget.categories
                  .map((category) => Tab(text: category))
                  .toList(),
            ),
          ),
          // Pages
          Expanded(
            child:
                widget.customBody ??
                TabBarView(controller: _tabController, children: widget.pages),
          ),
        ],
      ),
    );
  }
}
