import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product_list.dart';
import '../components/product_grid.dart';
import '../models/product.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert), iconColor: Colors.white,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
                ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
                ),
            ],
            onSelected: (FilterOptions selectedValue) {
              if(selectedValue == FilterOptions.Favorite) {
                provider.showFavoritesOnly();
              } 
              else {
                provider.showAll();
              }
            },
            ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}
