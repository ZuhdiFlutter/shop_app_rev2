import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products_prov.dart';

class ProductDetailScreen extends StatelessWidget {
  // uncomment to use push intead of pushNamed
  // final Product product;
  // ProductDetailScreen(this.product);
  static const route = "prod_detail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((element) => element.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadedProduct.price}",
              style: TextStyle(color: Colors.grey[700], fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(loadedProduct.description),
            ),
          ],
        ),
      ),
    );
  }
}
