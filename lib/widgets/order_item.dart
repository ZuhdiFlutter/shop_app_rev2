import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      height:
          _expanded ? min(widget.order.product.length * 20.0 + 122, 200) : 95,
      curve: Curves.easeIn,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.order.amount}"),
              subtitle: Text(DateFormat("dd/MM").format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 350),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              height: _expanded
                  ? min(widget.order.product.length * 20.0 + 30, 180)
                  : 0,
              child: ListView(
                children: widget.order.product
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${prod.quantity}x \$${prod.price}",
                            style:
                                TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
