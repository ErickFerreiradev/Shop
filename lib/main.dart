import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/product_detail_page.dart';
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
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 90, 78), 
            primary: const Color.fromARGB(255, 255, 90, 78),
            secondary: Colors.deepOrange,),
          appBarTheme: (
            AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 255, 90, 78),
              centerTitle: true,
          
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Lato',)
            )
          ),
          useMaterial3: true,
        ),
        home: ProductsOverviewPage(),
        routes: {
         AppRoutes.productDetail: (ctx) => ProductDetailPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
