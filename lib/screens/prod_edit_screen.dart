import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../providers/products_prov.dart';

class EditProductScreen extends StatefulWidget {
  static const route = "Edit";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceNode = FocusNode();
  final descNode = FocusNode();
  final imageController = TextEditingController();
  final imageNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var editedProd = Product(
    id: null,
    price: 0,
    title: "",
    description: "",
    imageUrl: "",
  );
  var initVal = {
    "title": "",
    "description": '',
    'price': '',
    'image': '',
  };
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    imageNode.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        editedProd =
            Provider.of<Products>(context, listen: false).findById(prodId);
        initVal = {
          'title': editedProd.title,
          'description': editedProd.description,
          'price': editedProd.price.toString(),
          // 'image': editedProd.imageUrl,
          'image': '',
        };
        imageController.text = editedProd.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    imageNode.removeListener(updateImage);
    priceNode.dispose();
    descNode.dispose();
    imageNode.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!imageNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.validate();
    _form.currentState.save();
    if (editedProd.id != null) {
      Provider.of<Products>(context).updateProduct(editedProd.id, editedProd);
    } else {
      Provider.of<Products>(context).addProduct(editedProd);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: initVal['title'],
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please fill in";
                    }
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceNode);
                  },
                  onSaved: (val) {
                    editedProd = Product(
                      id: editedProd.id,
                      price: editedProd.price,
                      title: val,
                      description: editedProd.description,
                      imageUrl: editedProd.imageUrl,
                      isFav: editedProd.isFav,
                    );
                  },
                ),
                TextFormField(
                  initialValue: initVal['price'],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please fill in";
                    }
                  },
                  keyboardType: TextInputType.number,
                  focusNode: priceNode,
                  onSaved: (val) {
                    editedProd = Product(
                      id: editedProd.id,
                      isFav: editedProd.isFav,
                      price: double.parse(val),
                      title: editedProd.title,
                      description: editedProd.description,
                      imageUrl: editedProd.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  initialValue: initVal['description'],
                  decoration: InputDecoration(labelText: "Description"),
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please fill in";
                    }
                  },
                  focusNode: descNode,
                  onSaved: (val) {
                    editedProd = Product(
                      id: editedProd.id,
                      isFav: editedProd.isFav,
                      price: editedProd.price,
                      title: editedProd.title,
                      description: val,
                      imageUrl: editedProd.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: imageController.text.isEmpty
                          ? Text("Enter a Image URL")
                          : FittedBox(
                              child: Image.network(imageController.text),
                              fit: BoxFit.cover,
                            ),
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Image URL"),
                        textInputAction: TextInputAction.done,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please fill in";
                          }
                          if (!(val.endsWith(".png") || val.endsWith(".jpg"))) {
                            return "Enter a valid URL";
                          }
                        },
                        keyboardType: TextInputType.url,
                        controller: imageController,
                        focusNode: imageNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (val) {
                          editedProd = Product(
                            id: editedProd.id,
                            isFav: editedProd.isFav,
                            price: editedProd.price,
                            title: editedProd.title,
                            description: editedProd.description,
                            imageUrl: val,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
