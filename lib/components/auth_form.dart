import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> 
  with SingleTickerProviderStateMixin{
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
        ),
      );

    _heightAnimation = Tween(
      begin: Size(double.infinity, 310),
      end: Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _controller!, 
        curve: Curves.linear,
        ),
    );

    _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }


  void _switchAuthMode() {
    setState(() {
      if(_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('Fechar'),
            )
        ],
      ),
      );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } 

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(top: 10),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        // height: _isLogin() ? 310 : 400,
        height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if(password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if(_isSignup())
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmar a senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: _isLogin()
                ? null 
                : (_password) {
                  final password = _password ?? '';
                  if(password != _passwordController.text){
                    return 'Senhas informadas não conferem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              if(_isLoading)
              CircularProgressIndicator()
              else
              ElevatedButton(
                onPressed: _submit, 
                child: Text(
                 _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8,),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _switchAuthMode, 
                  child: Text(
                    _isLogin() ? 'DESEJA REGISTAR?' : 'JÁ POSSUI CONTA?',
                  )
                  ),
            ],
          ),
        ),
      ),
    );
  }
}