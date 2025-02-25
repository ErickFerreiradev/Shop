import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/cart.dart';
class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false); //FALSO PARA USO DO DO CONSUMER
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          ),
          onTap: (){ Navigator.of(context).pushNamed(
            AppRoutes.productDetail,
            arguments: product,
          );
          },
        ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavorite();
                }, 
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border), 
                color: Theme.of(context).colorScheme.secondary,
                ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Adicionado com sucesso!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'DESFAZER', 
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }
                      ),
                    ),
                );
              }, 
              icon: Icon(Icons.shopping_cart),
              color: const Color.fromARGB(255, 187, 248, 189),
              ),
          ),
        ),
    );
  }
}