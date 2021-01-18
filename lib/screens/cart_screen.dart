import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const route = "Cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ((widget.cart.totalAmount <= 0) || (isLoading == true))
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text("Buy Now", style: TextStyle(fontSize: 20)),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
