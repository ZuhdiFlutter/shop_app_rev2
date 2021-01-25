import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_prod_item.dart';

import '../providers/products_prov.dart';
import './prod_edit_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const route = "user prod";

  Future<void> _refreshProd(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProd(true);
  }

  @override
  Widget build(BuildContext context) {
    // final prodData = Provider.of<Products>(context);
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
      body: FutureBuilder(
        future: _refreshProd(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProd(context),
                    child: Consumer<Products>(
                      builder: (ctx, prodData, _) => Padding(
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
                    ),
                  ),
      ),
    );
  }
}
