import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';

import './screens/prod_overview_screen.dart';
import './screens/prod_detail_screen.dart';
import './providers/products_prov.dart';
import './screens/orders_screen.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: "My Shop",
        theme: ThemeData(
          primaryColor: Colors.orange[800],
          fontFamily: "Lato",
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductOverviewScreen.route: (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
          CartScreen.route: (ctx) => CartScreen(),
          OrderScreen.route: (ctx) => OrderScreen(),
        },
      ),
    );
  }
}
