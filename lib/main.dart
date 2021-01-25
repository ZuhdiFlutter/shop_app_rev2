import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/prod_overview_screen.dart';
import './screens/prod_detail_screen.dart';
import './providers/products_prov.dart';
import './screens/orders_screen.dart';
import './screens/user_prod_screen.dart';
import './screens/prod_edit_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // create: (ctx) => Products(),
          update: (
            ctx,
            auth,
            previousProd,
          ) =>
              Products(
            auth.token,
            auth.userId,
            previousProd == null ? [] : previousProd.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (
            ctx,
            auth,
            previousOrd,
          ) =>
              Orders(
            auth.token,
            auth.userId,
            previousOrd == null ? [] : previousOrd.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "My Shop",
          theme: ThemeData(
            primaryColor: Colors.orange[800],
            fontFamily: "Lato",
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnap) =>
                      authSnap.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductOverviewScreen.route: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
            CartScreen.route: (ctx) => CartScreen(),
            OrderScreen.route: (ctx) => OrderScreen(),
            UserProductScreen.route: (ctx) => UserProductScreen(),
            EditProductScreen.route: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
