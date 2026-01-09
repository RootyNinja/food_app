import 'package:flutter/material.dart';
import 'package:flutterfinalproject/Widgets/products_items_display.dart';
import 'package:flutterfinalproject/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Utils/consts.dart';
import '../../models/categories_model.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<FoodModel>> futureFoodProduct = Future.value([]);
  List<CategoryModel> categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final data = await futureCategories;
      if (data.isNotEmpty) {
        setState(() {
          categories = data;
          selectedCategory = data.first.name;
          futureFoodProduct = fetchFoodProduct(selectedCategory!);
        });
      }
    } catch (e) {
      debugPrint("Init Error: $e");
    }
  }

  Future<List<FoodModel>> fetchFoodProduct(String category) async {
    try {
      final response = await Supabase.instance.client
          .from("food_product")
          .select()
          .eq("category", category);

      return (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Fetch Products Error: $e");
      return [];
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from("category_items")
          .select();

      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Fetch Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _AppBanner(),
                SizedBox(height: 25),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildCategoryList(),
          const SizedBox(height: 30),
          viewAll(),
          const SizedBox(height: 30),
          _buildProductSelection(),
        ],
      ),
    );
  }

  Widget _buildProductSelection() {
    return Expanded(
      child: FutureBuilder<List<FoodModel>>(
        future: futureFoodProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                child: ProductsItemsDisplay(foodModel: product[index]),
              );
            },
          );
        },
      ),
    );
  }

  Padding viewAll() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Popular Now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            child: Row(
              children: [
                const Text("View All", style: TextStyle(color: Colors.orange)),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder<List<CategoryModel>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No Categories Found");
        }

        final products = snapshot.data!;

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final category = products[index];
              final isSelected = category.name == selectedCategory;

              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                child: GestureDetector(
                  onTap: () => handleCategoryTap(category.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : grey1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                          ),
                          child: Image.network(
                            category.image,
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTree) =>
                                const Icon(Icons.fastfood),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void handleCategoryTap(String category) {
    if (selectedCategory == category) return;
    setState(() {
      selectedCategory = category;
      futureFoodProduct = fetchFoodProduct(category);
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        const SizedBox(width: 25),
        _iconBox("assets/food-delivery/icon/dash.png"),
        const Spacer(),
        Row(
          children: const [
            Icon(Icons.location_on_outlined, size: 18, color: Colors.red),
            SizedBox(width: 5),
            Text(
              "Hassan Abdal, Pakistan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Colors.orange,
            ),
          ],
        ),
        const Spacer(),
        _iconBox("assets/food-delivery/profile.png"),
        const SizedBox(width: 25),
      ],
    );
  }

  Widget _iconBox(String asset) {
    return Container(
      height: 45,
      width: 45,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(asset),
    );
  }
}

class _AppBanner extends StatelessWidget {
  const _AppBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
      decoration: BoxDecoration(
        color: imageBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "The Fastest In Delivery ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Food",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Order Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/food-delivery/courier.png"),
        ],
      ),
    );
  }
}
