import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myntra/data_config.dart';
import 'package:myntra/models/CategoryModel.dart';
import 'package:myntra/pages/product_details/product_details_page.dart';
import 'package:myntra/widget/customcheckbox.dart';
import 'package:myntra/widget/customedropdown.dart';
import 'package:myntra/widget/mediaqurry.dart';

class HmPage extends StatefulWidget {
  const HmPage({super.key});

  @override
  State<HmPage> createState() => _WomenPageState();
}

class _WomenPageState extends State<HmPage> {
  String? selectedFilter;
  List<String> selectedCheckboxes = [];
  late List<CategoryItem> categories = [];
  Map<String, List<String>> filterOptions = {}; // For dynamic checkbox options

  String? tempSelectedFilter;
  List<String> tempSelectedCheckboxes = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadFilterOptions();
  }

  // Load categories for product grid
  Future<void> loadCategories() async {
    final List<dynamic> rawValues = (women["catalogs"] as List<dynamic>?) ?? [];
    categories = rawValues
        .map((e) => CategoryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    setState(() {}); // Refresh after loading
  }

  // Load title from assets
  Future<String> _loadTitle() async {
    String jsonString = await rootBundle.loadString('assets/data/title.json');
    Map<String, dynamic> data = json.decode(jsonString);
    return data["Women"] ?? "Men's Collection";
  }

  // Load filter options dynamically
  Future<void> loadFilterOptions() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/data/filter.json',
      );
      Map<String, dynamic> data = json.decode(jsonString);

      filterOptions = data.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );

      print("Loaded filter options: $filterOptions"); // Debug log
      setState(() {}); // Refresh UI
    } catch (e) {
      print("Error loading filter options: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Apply filtering based on selected checkboxes
    List<CategoryItem> filteredCategories = categories.where((item) {
      if (selectedCheckboxes.isEmpty)
        return true; // Show all if no filter selected
      return selectedCheckboxes.any(
        (filter) => item.subCategory.toLowerCase() == filter.toLowerCase(),
      );
    }).toList();

    //-----------------
    if (selectedFilter != null) {
      if (selectedFilter == 'Price(Low to High)') {
        filteredCategories.sort((a, b) => a.price.compareTo(b.price));
      } else if (selectedFilter == 'Price(High to Low)') {
        filteredCategories.sort((a, b) => b.price.compareTo(a.price));
      }
    }
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
            if (Responsive.isMobile) {
              // ✅ Mobile layout
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        width: 500,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.25,
                            ),
                          ),
                          color: Colors.white10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // ✅ Tablet & Desktop layout
              return Scaffold(body: Row(children: [

                  ],
                ));
            }
          },
        );
      },
    );
  }
}
