import 'package:flutter/material.dart';
import 'package:flutterfinalproject/models/product_model.dart';

class ProductsItemsDisplay extends StatefulWidget {
  final FoodModel foodModel;

  const ProductsItemsDisplay({super.key, required this.foodModel});

  @override
  State<ProductsItemsDisplay> createState() => _ProductsItemsDisplayState();
}

class _ProductsItemsDisplayState extends State<ProductsItemsDisplay> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            child: Container(
              height: 180,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    spreadRadius: 10,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: size.width * 0.5,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  width: 150,
                  height: 140,
                  fit: BoxFit.fill,
                  widget.foodModel.imageCard,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.foodModel.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  widget.foodModel.specialItems,
                  style: TextStyle(
                    height: 0.1,
                    letterSpacing: 0.5,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30,),
                RichText(text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold,),
                    children: [
                      TextSpan(
                        text: "\$",
                        style: TextStyle(fontSize: 14, color: Colors.black),

                      )
                    ]
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
