import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myntra/data_config.dart';
import 'package:myntra/models/CategoryModel.dart';
import 'package:myntra/pages/product_details/product_details_page.dart';
import 'package:myntra/widget/customcheckbox.dart';
import 'package:myntra/widget/customedropdown.dart';
import 'package:myntra/widget/mediaqurry.dart';
import 'package:intl/intl.dart';

class WomenPage extends StatefulWidget {
  const WomenPage({super.key});

  @override
  State<WomenPage> createState() => _WomenPageState();
}

class _WomenPageState extends State<WomenPage> {
  String? selectedFilter;

  String? selectedDateFilter; // Default to All
  List<String> selectedCheckboxes = [];
  late List<CategoryItem> categories = [];
  Map<String, List<String>> filterOptions = {}; // For dynamic checkbox options

  String? tempSelectedFilter;
  List<String> tempSelectedCheckboxes = [];
  String? tempSelecteddate;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? tempFromDate;
  DateTime? tempToDate;

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
    //--------------------------------------------------------------------Apply date filter logic
    if (selectedDateFilter == 'Latest') {
      DateTime cutoffDate = DateTime(2025, 8, 15);
      filteredCategories = filteredCategories.where((item) {
        try {
          DateTime createdDate = DateTime.parse(item.createdAt);
          return createdDate.isAfter(cutoffDate);
        } catch (e) {
          return false; // -----------------------------------------------Skip if date parse fails
        }
      }).toList();
    }
    if (fromDate != null && toDate != null) {
      filteredCategories = filteredCategories.where((item) {
        try {
          DateTime createdDate = DateTime.parse(item.createdAt);
          return (createdDate.isAfter(fromDate!) ||
                  createdDate.isAtSameMomentAs(fromDate!)) &&
              (createdDate.isBefore(toDate!) ||
                  createdDate.isAtSameMomentAs(toDate!));
        } catch (e) {
          return false;
        }
      }).toList();
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
                      Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Card(
                        child: CustomDropdown(
                          items: const ['All', 'Latest'],
                          initialValue: tempSelecteddate ?? selectedDateFilter,
                          onChanged: (val) {
                            setState(() {
                              tempSelecteddate = val;
                            });
                          },
                        ),
                      ),
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // From Date Picker
                            TextButton(
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2025),
                                  lastDate: DateTime.now(), // ✅ No future date
                                );
                                if (picked != null) {
                                  setState(() {
                                    tempFromDate = picked;

                                    // If tempToDate exists and is before the new tempFromDate, reset it
                                    if (tempToDate != null &&
                                        tempToDate!.isBefore(tempFromDate!)) {
                                      tempToDate = null;
                                    }
                                  });
                                }
                              },
                              child: Text(
                                tempFromDate == null
                                    ? "Select From Date"
                                    : "From: ${tempFromDate!.toLocal()}".split(
                                        ' ',
                                      )[0],
                              ),
                            ),

                            // To Date Picker
                            TextButton(
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      tempFromDate ??
                                      DateTime(
                                        2025,
                                      ), // ✅ Start from selected From Date
                                  lastDate: DateTime.now(), // ✅ No future date
                                );
                                if (picked != null) {
                                  setState(() {
                                    tempToDate = picked;
                                  });
                                }
                              },
                              child: Text(
                                tempToDate == null
                                    ? "Select To Date"
                                    : "To: ${tempToDate!.toLocal()}".split(
                                        ' ',
                                      )[0],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Card(
                        child: CustomDropdown(
                          items: const [
                            'Price(Low to High)',
                            'Price(High to Low)',
                          ],
                          initialValue: tempSelectedFilter ?? selectedFilter,
                          onChanged: (val) {
                            setState(() {
                              tempSelectedFilter = val; // <-- store temporarily
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 190,
                        child: Card(
                          child: filterOptions.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : CustomCheckbox(
                                  options: filterOptions["Women"] ?? [],
                                  selectedOptions: selectedCheckboxes,
                                  onChanged: (selected) {
                                    setState(() {
                                      tempSelectedCheckboxes =
                                          selected; // <-- store temporarily
                                      print(
                                        "Selected Filters: $selectedCheckboxes",
                                      );
                                    });
                                  },
                                ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = tempSelectedFilter;
                            selectedDateFilter = tempSelecteddate;
                            selectedCheckboxes = List.from(
                              tempSelectedCheckboxes,
                            );
                            fromDate = tempFromDate;
                            toDate = tempToDate;
                          });
                        },
                        child: const Text("Apply Filters"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            tempSelectedFilter = null;
                            tempSelectedCheckboxes.clear();
                            selectedFilter = null;
                            selectedCheckboxes.clear();
                            fromDate = null;
                            toDate = null;
                            tempFromDate = null;
                            tempToDate = null;
                          });
                        },
                        child: const Text("Clear Filters"),
                      ),
                      Container(
                        height: 600,
                        color: const Color.fromARGB(255, 242, 243, 244),
                        padding: const EdgeInsets.all(8),
                        child: filteredCategories.isEmpty
                            ? const Center(
                                child: Text(
                                  "No products found",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: filteredCategories.map((item) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailPage(item: item),
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
                                              fontWeight: FontWeight.bold,
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
              // ✅ Tablet & Desktop layout
              return Scaffold(
                body: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Card(
                              child: CustomDropdown(
                                items: const ['All', 'Latest'],
                                initialValue:
                                    tempSelecteddate ?? selectedDateFilter,
                                onChanged: (val) {
                                  setState(() {
                                    tempSelecteddate = val;
                                  });
                                },
                              ),
                            ),
                            Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // From Date Picker
                                  TextButton(
                                    onPressed: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2025, 01, 01),
                                        lastDate:
                                            DateTime.now(), // ✅ No future date
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          tempFromDate = picked;

                                          // If tempToDate exists and is before the new tempFromDate, reset it
                                          if (tempToDate != null &&
                                              tempToDate!.isBefore(
                                                tempFromDate!,
                                              )) {
                                            tempToDate = null;
                                          }
                                        });
                                      }
                                    },
                                    child: Text(
                                      tempFromDate == null
                                          ? "Select From Date"
                                          : "From: ${tempFromDate!.toLocal()}"
                                                .split(' ')[0],
                                    ),
                                  ),

                                  // To Date Picker
                                  TextButton(
                                    onPressed: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            tempFromDate ??
                                            DateTime(
                                              2025,
                                            ), // ✅ Start from selected From Date
                                        lastDate:
                                            DateTime.now(), // ✅ No future date
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          tempToDate = picked;
                                        });
                                      }
                                    },
                                    child: Text(
                                      tempToDate == null
                                          ? "Select To Date"
                                          : "To: ${tempToDate!.toLocal()}"
                                                .split(' ')[0],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Card(
                              child: CustomDropdown(
                                items: const [
                                  'Price(Low to High)',
                                  'Price(High to Low)',
                                ],
                                initialValue:
                                    tempSelectedFilter ?? selectedFilter,
                                onChanged: (val) {
                                  setState(() {
                                    tempSelectedFilter =
                                        val; // <-- store temporarily
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 290,
                              child: filterOptions.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CustomCheckbox(
                                      options: filterOptions["Women"] ?? [],
                                      selectedOptions:
                                          tempSelectedCheckboxes.isNotEmpty
                                          ? tempSelectedCheckboxes
                                          : selectedCheckboxes,
                                      onChanged: (selected) {
                                        setState(() {
                                          tempSelectedCheckboxes =
                                              selected; // <-- store temporarily
                                          print(
                                            "Selected Filters: $selectedCheckboxes",
                                          );
                                        });
                                      },
                                    ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // Confirm temp values
                                  selectedFilter = tempSelectedFilter;
                                  selectedDateFilter =
                                      tempSelecteddate; // ✅ Apply date filter here

                                  selectedCheckboxes = List.from(
                                    tempSelectedCheckboxes,
                                  );
                                  fromDate = tempFromDate;
                                  toDate = tempToDate;
                                });
                              },
                              child: const Text("Apply Filters"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  tempSelectedFilter = null;
                                  tempSelectedCheckboxes.clear();
                                  selectedFilter = null;
                                  selectedCheckboxes.clear();
                                  tempSelecteddate = null;
                                  selectedDateFilter = null;
                                  fromDate = null;
                                  toDate = null;
                                  tempFromDate = null;
                                  tempToDate = null;
                                });
                              },
                              child: const Text("Clear Filters"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 242, 243, 244),
                        child: filteredCategories.isEmpty
                            ? const Center(
                                child: Text(
                                  "No products found",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: Responsive.isTablet ? 3 : 5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: filteredCategories.map((item) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailPage(item: item),
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
                                              fontWeight: FontWeight.bold,
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
