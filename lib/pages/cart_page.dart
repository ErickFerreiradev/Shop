import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    ),
                    SizedBox(width: 10,),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'R\$${cart.totalAmount}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {}, 
                      child: Text('COMPRAR'),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(items[i],),
              ),
              )
        ],
      ),
      );
  }
}