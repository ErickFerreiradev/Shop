import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
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
              onPressed: (){},
               icon: Icon(Icons.delete),
               color: Theme.of(context).colorScheme.error
               ),
          ],
        ),
      ),
    );
  }
}