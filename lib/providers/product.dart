import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.imageUrl,
    this.isFav = false,
    @required this.price,
    @required this.title,
    @required this.description,
  });

  Future<void> toggleFavStatus(String token, String userId) async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    final url =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/userFav/$userId/$id.json?=auth=$token";
    try {
      await http.put(
        url,
        body: jsonEncode(
          isFav,
        ),
      );
    } catch (error) {
      isFav = oldStatus;
    }
  }
}
