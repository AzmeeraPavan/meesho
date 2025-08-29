// class Pagedetails {
//   final int price;
//   final String name;
//   final String imageUrl;
//   final String description;
//   final int reviewCount; // Nested value from catalog_reviews_summary
//   final bool selected;

//   Pagedetails({
//     required this.price,
//     required this.name,
//     required this.imageUrl,
//     required this.description,
//     required this.reviewCount,
//     this.selected = false,
//   });

//   factory Pagedetails.fromJson(Map<String, dynamic> json) {
//     return Pagedetails(
//       price: json['min_product_price'] ?? 0,
//       name: json['name'] ?? '',
//       imageUrl: json['image'] ?? '',
//       description: json['description'] ?? '',
//       reviewCount: json['catalog_reviews_summary'] != null
//           ? (json['catalog_reviews_summary']['review_count'] ?? 0)
//           : 0,
//       selected: false,
//     );
//   }
// }
