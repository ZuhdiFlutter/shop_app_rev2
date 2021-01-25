import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> allItems = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [...allItems];
  }

  List<Product> get favItems {
    return allItems.where((element) => element.isFav).toList();
  }

  List<Product> favProd = [];

  Future<void> addProduct(Product product) {
    final url =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/products.json?=auth=$token";
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }),
    )
        .then(
      (resp) {
        final newProd = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: jsonDecode(resp.body)['name'],
        );
        allItems.add(newProd);
        print("added");
        print(newProd.id);
        notifyListeners();
      },
    ).catchError((error) {
      throw error;
    });
  }

  List presentId(String prodId) {
    List<Product> presence = [];
    allItems.forEach((prod) {
      if (prod.id == prodId) {
        presence.add(prod);
      }
    });
    return presence;
  }

  String token;
  String userId;
  Products(this.token, this.userId, this.allItems);

  Future<void> fetchProd([bool filterByUser = false]) async {
    final filterString =
        filterByUser == true ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shop-app-472ce-default-rtdb.firebaseio.com/products.json?=auth=$token$filterString';

    final favUrl =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/userFav/$userId.json?=auth=$token";

    try {
      final response = await http.get(url);
      final favResponse = await http.get(favUrl);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final favData = jsonDecode(favResponse.body) as Map<String, dynamic>;
      final List<Product> loadedProd = [];
      if (data == null) {
        return;
      }

      data.forEach(
        (prodId, prodData) {
          print(prodData); // problem is permission denied!!!!!!!!!!!!!!!!
          if (presentId(prodId).isEmpty) {
            loadedProd.add(Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              isFav: favData == null ? false : favData[prodId] ?? false,
            ));
            print(prodData['title']);
          } else
            return;
        },
      );
      allItems = allItems + loadedProd;

      print(data);
      notifyListeners();
    } catch (error) {
      allItems = [];
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = allItems.indexWhere((prod) => prod.id == id);
    final url =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/products/$id.json?=auth=$token";
    await http.patch(
      url,
      body: jsonEncode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }),
    );
    allItems[prodIndex] = newProduct;
    notifyListeners();
  }

  // var _showFavouriteOnly = false;

  // void showFavOnly() {
  //   _showFavouriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouriteOnly = false;
  //   notifyListeners();
  // }

  Product findById(String prodId) {
    var foundIndex = items.indexWhere((prod) => prod.id == prodId);
    return items[foundIndex];
  }

  Future<void> deleteProd(String prodId) async {
    final url =
        "https://shop-app-472ce-default-rtdb.firebaseio.com/products/$prodId.json?=auth=$token";
    final existingProdIndex = items.indexWhere((prod) => prod.id == prodId);
    var existingProd = items[existingProdIndex];
    items.removeAt(existingProdIndex);
    allItems.removeWhere((prod) => prod.id == prodId);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException("Delete failed!");
    }
    existingProd = null;

    notifyListeners();
  }
}

void showListUpdates(List favList) {
  print(favList);
}
