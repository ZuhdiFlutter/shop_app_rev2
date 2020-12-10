import 'package:flutter/material.dart';

import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/prod_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final Product product;
  // ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context,
        listen:
            false); // listen is false because we dont want to update the widget, only pass data

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.route, arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon:
                  Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavStatus();
                print(product.title);
                print(product.isFav);
                //  showListUpdates(favList);
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                print(product.title);
              },
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
