import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../providers/products_prov.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const route = "Home";
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showOnlyFav = false;
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      isLoading = true;
      Provider.of<Products>(context).fetchProd().then((_) {
        isLoading = false;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final prodContainer = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopy",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            // ----------------------------------------------------M1 got error
            onSelected: (FilterOptions selectedVal) {
              setState(
                () {
                  if (selectedVal == FilterOptions.Favorites) {
                    showOnlyFav = true;
                    print(selectedVal);
                  } else {
                    showOnlyFav = false;
                    print(selectedVal);
                  }
                },
              );
            },
            // ------------------------------------------------M2 doesnot work
            // onSelected: (FilterOptions selectedVal) {
            //   if (selectedVal == FilterOptions.All) {
            //     prodContainer.showAll();
            //   } else if (selectedVal == FilterOptions.Favorites) {
            //     prodContainer.showFavOnly();
            //   }
            // },
            // onSelected: (FilterOptions selectedVal) {
            //   if (selectedVal == FilterOptions.All) {
            //     setState(() {
            //       // prodContainer.showAll();
            //       showOnlyFav = false;
            //     });
            //   } else if (selectedVal == FilterOptions.Favorites) {
            //     setState(() {
            //       // prodContainer.showFavOnly();
            //       showOnlyFav = true;
            //     });
            //   }
            // },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Wishlist"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, chld) => Badge(
              child: chld,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                return Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlyFav),
    );
  }
}
