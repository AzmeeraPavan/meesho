import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myntra/data_config.dart';
import 'package:myntra/models/CategoryModel.dart';
import 'package:myntra/pages/product_details/product_details_page.dart';
import 'package:myntra/widget/customcheckbox.dart';
import 'package:myntra/widget/customedropdown.dart';
import 'package:myntra/widget/mediaqurry.dart';

class HomekPage extends StatefulWidget {
  const HomekPage({super.key});

  @override
  State<HomekPage> createState() => _MenPageState();
}

class _MenPageState extends State<HomekPage> {
  String? selectedFilter;
  List<String> selectedCheckboxes = [];
  late List<CategoryItem> categories = [];
  Map<String, List<String>> filterOptions = {}; // For dynamic checkbox options

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadFilterOptions();
  }

  Future<void> loadCategories() async {
    final List<dynamic> rawValues = (homek["catalogs"] as List<dynamic>?) ?? [];
    categories = rawValues
        .map((e) => CategoryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    setState(() {}); // Refresh after loading
  }

  Future<String> _loadTitle() async {
    String jsonString = await rootBundle.loadString('assets/data/title.json');
    Map<String, dynamic> data = json.decode(jsonString);
    return data["Men"] ?? "Men's Collection";
  }

  Future<void> loadFilterOptions() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/data/filter.json',
      );
      Map<String, dynamic> data = json.decode(jsonString);

      filterOptions = data.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );

      setState(() {}); // Refresh UI
    } catch (e) {
      print("Error loading filter options: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return FutureBuilder<String>(
      future: _loadTitle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // final isMobile = constraints.maxWidth < 650;

            if (Responsive.isMobile) {
              // Mobile layout: filters on top, products below stacked vertically
              return Scaffold(
                // appBar: AppBar(title: Text(snapshot.data!)),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filters full width
                      Text(snapshot.data!),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: CustomDropdown(
                            items: const [
                              'NewArrivals',
                              'Price(Low to High)',
                              'Price(High to Low)',
                              'Ratings',
                              'Discount',
                            ],
                            initialValue: selectedFilter,
                            onChanged: (val) {
                              setState(() {
                                selectedFilter = val;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 320,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: CustomCheckbox(
                              options: filterOptions["Women"] ?? [],
                              selectedOptions: selectedCheckboxes,
                              onChanged: (selected) {
                                setState(() {
                                  selectedCheckboxes = selected;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      // Product grid full width
                      Container(
                        height: 600,
                        color: const Color.fromARGB(255, 242, 243, 244),
                        padding: const EdgeInsets.all(8),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: categories.map((item) {
                            return GestureDetector(
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => ProductDetailPage(item: item),
                              //   ),
                              // ),
                              child: Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      '₹${item.price}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Tablet & Desktop layout: filters left side, products right side
              return Scaffold(
                // appBar: AppBar(title: Text(snapshot.data!)),
                body: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(snapshot.data!),
                            Card(
                              child: CustomDropdown(
                                items: const [
                                  'NewArrivals',
                                  'Price(Low to High)',
                                  'Price(High to Low)',
                                  'Ratings',
                                  'Discount',
                                ],
                                initialValue: selectedFilter,
                                onChanged: (val) {
                                  setState(() {
                                    selectedFilter = val;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 490,
                              child: CustomCheckbox(
                                options: filterOptions["Women"] ?? [],
                                selectedOptions: selectedCheckboxes,
                                onChanged: (selected) {
                                  setState(() {
                                    selectedCheckboxes = selected;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 242, 243, 244),
                        child: GridView.count(
                          crossAxisCount: Responsive.isTablet ? 3 : 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: categories.map((item) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(item: item),
                                ),
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      '₹${item.price}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
