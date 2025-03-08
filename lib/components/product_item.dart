import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';
import '../models/product_list.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(
                  AppRoutes.product_form,
                  arguments: product,
                );
              },
               icon: Icon(Icons.edit,),
               color: Theme.of(context).colorScheme.primary,
               ),
            IconButton(
              onPressed: (){
                showDialog(context: context, builder: (ctx) => AlertDialog(
                  title: Text('Excluir Produto'),
                  content: Text('Tem certeza?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                       child: Text('Não'),
                       ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                       child: Text('Sim'),
                       ),
                  ],
                ),
                ).then((value) async {
                  if (value ?? false ) {
                  try {
                    await Provider.of<ProductList>(
                      context,
                      listen: false,
                    ).removeProduct(product);
                  } on HttpException catch(error) {
                    msg.showSnackBar(
                      SnackBar(content: Text(error.toString()))
                    );
                  }
                  }
                });
              },
               icon: Icon(Icons.delete),
               color: Theme.of(context).colorScheme.error
               ),
          ],
        ),
      ),
    );
  }
}