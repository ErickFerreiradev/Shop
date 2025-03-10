import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product__grid_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';
import '../components/product_grid.dart';
import '../models/product.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final cart = Provider.of<Cart>(context);

    final counter = cart.itemsCount.toString();
  
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
            Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white,),
            ),
            builder: (ctx, cart, child) =>  Badge(
              alignment: Alignment(0.4,-0.6),
              label: Text('${counter}'),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductGrid(),
      drawer: AppDrawer(),
    );
  }
}
