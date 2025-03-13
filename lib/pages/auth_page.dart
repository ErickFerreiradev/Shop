import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(194, 26, 49, 0.482),
                  Color.fromRGBO(255, 180, 99, 0.894)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                )
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  child: Text(
                    'Minha Loja',
                    style: TextStyle(
                      fontSize: 45,
                      
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

