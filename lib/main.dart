import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '', 
              auth.userId ?? '', 
              previous?.items ?? []
              );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255), 
            primary: const Color.fromARGB(255, 255, 90, 78),
            secondary: Colors.deepOrange,
            
            ),
          appBarTheme: (
            AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 255, 90, 78),
              centerTitle: true,
          
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Lato',)
            )
          ),
          useMaterial3: true,
        ),
        // home: ProductsOverviewPage(),
        routes: {
         AppRoutes.auth_or_home: (ctx) => AuthOrHomePage(),
         AppRoutes.productDetail: (ctx) => ProductDetailPage(),
         AppRoutes.cart: (ctx) => CartPage(),
         AppRoutes.orders: (ctx) => OrdersPage(),
         AppRoutes.products: (ctx) => ProductsPage(),
         AppRoutes.product_form: (ctx) => ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
