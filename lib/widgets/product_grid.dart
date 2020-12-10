import 'package:flutter/material.dart';
import 'package:provider/provider.dart ';

import './product_item.dart';
import '../providers/products_prov.dart';

class ProductGrid extends StatefulWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFavs ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (ctx) => products[i],
        value: products[i],
        child: ProductItem(
            // products[i],
            ),
      ),
      itemCount: products.length,
    );
  }
}
