import 'package:flutter/material.dart';
import "../screens/prod_edit_screen.dart";
import 'package:provider/provider.dart';
import '../providers/products_prov.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaf = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.route, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                try {
                  Provider.of<Products>(context).deleteProd(id);
                } catch (error) {
                  scaf.showSnackBar(SnackBar(
                    content: Text('Deleting failed!'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
