// ignore_for_file: file_names

class CategoryItem {
  final int? id;
  final int heroPid;
  final String name;
  final int categoryId;
  final String subCategory;
  final String description;
  final String fullDetails;
  final int price;
  final int minCatalogPrice;
  final String imageUrl;
  final String collageImageUrl;
  final int numDesigns;
  final int numSuppliers;
  final String createdAt;
  final bool assured;
  final int reviewCount;
  final int ratingCount;
  final int averageRating;
  final String averageRatingStr;
  final String heroProductName;
  final String specialOfferText;
  final List<String> tags;
  final List<String> productImages;
  final int shippingCharges;
  final int shippingDiscount;
  final bool selected;

  CategoryItem({
    this.id,
    this.heroPid = 0,
    required this.name,
    this.categoryId = 0,
    this.subCategory = '',
    this.description = '',
    this.fullDetails = '',
    this.price = 0,
    this.minCatalogPrice = 0,
    this.imageUrl = '',
    this.collageImageUrl = '',
    this.numDesigns = 0,
    this.numSuppliers = 0,
    this.createdAt = '',
    this.assured = false,
    this.reviewCount = 0,
    this.ratingCount = 0,
    this.averageRating = 0,
    this.averageRatingStr = '',
    this.heroProductName = '',
    this.specialOfferText = '',
    this.tags = const [],
    this.productImages = const [],
    this.shippingCharges = 0,
    this.shippingDiscount = 0,
    this.selected = false,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    final reviewSummary = json['catalog_reviews_summary'];
    final assuredDetails = json['assured_details'];
    final specialOffers = json['special_offers'];

    return CategoryItem(
      id: json['id'],
      heroPid: json['hero_pid'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['category_id'] ?? 0,
      subCategory: json['sub_sub_category_name'] ?? '',
      description: json['description'] ?? '',
      fullDetails: json['full_details'] ?? '',
      price: json['min_product_price'] ?? 0,
      minCatalogPrice: json['min_catalog_price'] ?? 0,
      averageRating: json['average_rating'] ?? 0,
      imageUrl: json['image'] ?? '',
      collageImageUrl: json['collage_image'] ?? '',
      numDesigns: json['num_designs'] ?? 0,
      numSuppliers: json['num_suppliers'] ?? 0,
      createdAt: json['created_iso'] ?? '',
      assured: assuredDetails != null
          ? (assuredDetails['is_assured'] ?? false)
          : false,
      reviewCount: reviewSummary != null
          ? (reviewSummary['review_count'] ?? 0)
          : 0,
      ratingCount: reviewSummary != null
          ? (reviewSummary['rating_count'] ?? 0)
          : 0,
      averageRatingStr: reviewSummary != null
          ? (reviewSummary['average_rating_str'] ?? '')
          : '',
      heroProductName: json['hero_product_name'] ?? '',
      specialOfferText: specialOffers != null
          ? (specialOffers['display_text'] ?? '')
          : '',
      tags:
          (json['tags'] as List?)?.map((e) => e['name'].toString()).toList() ??
          [],
      productImages:
          (json['product_images'] as List?)
              ?.map((e) => e['url'].toString())
              .toList() ??
          [],
      shippingCharges: json['shipping'] != null
          ? (json['shipping']['charges'] ?? 0)
          : 0,
      shippingDiscount: json['shipping'] != null
          ? (json['shipping']['discount'] ?? 0)
          : 0,
      selected: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hero_pid': heroPid,
    'name': name,
    'category_id': categoryId,
    'subCategory': subCategory,
    'description': description,
    'fullDetails': fullDetails,
    'price': price,
    'minCatalogPrice': minCatalogPrice,
    'imageUrl': imageUrl,
    'collageImageUrl': collageImageUrl,
    'numDesigns': numDesigns,
    'numSuppliers': numSuppliers,
    'createdAt': createdAt,
    'assured': assured,
    'reviewCount': reviewCount,
    'ratingCount': ratingCount,
    'averageRating': averageRating,
    'averageRatingStr': averageRatingStr,
    'heroProductName': heroProductName,
    'specialOfferText': specialOfferText,
    'tags': tags,
    'productImages': productImages,
    'shippingCharges': shippingCharges,
    'shippingDiscount': shippingDiscount,
    'selected': selected,
  };
}
