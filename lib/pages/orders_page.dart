import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});


  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<OrderList>(
      context,
       listen: false,
       ).loadOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
       });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) 
      : RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: ListView.builder(
          itemCount: orders.itensCount,
          itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i])
          ),
      )
    );
  }
}