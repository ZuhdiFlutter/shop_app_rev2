import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_prod_item.dart';

import '../providers/products_prov.dart';
import './prod_edit_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const route = "user prod";
  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.route);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: prodData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                prodData.items[i].id,
                prodData.items[i].title,
                prodData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
