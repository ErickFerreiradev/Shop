import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(_formData.isEmpty){
      final arg = ModalRoute.of(context)?.settings.arguments;

      if(arg != null){
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['nome'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWitchFile = url.toLowerCase().endsWith('.png') ||
     url.toLowerCase().endsWith('.jpg') ||
      url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWitchFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });
    
    Provider.of<ProductList>(context, listen: false).saveProductFromData(_formData).catchError((error) {
      return showDialog<void>(
        context: context,
         builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro'),
          content: Text('Ocorreu um erro para salvar o produto.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
               child: Text('Ok'),
               ),
          ],
         ),
         );
    }).then((value) {
        setState(() =>  _isLoading = false);
       Navigator.of(context).pop();
       });

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: _submitForm,
             icon: Icon(Icons.save),
             ),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_description) {
                  final name = _description ?? '';

                  if(name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  
                  if(name.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if(price <= 0) {
                    return 'Informe um preço válido';
                  }
                  
                  return null;

                },
                
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocus);
                },
                onSaved: (description) => _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';

                  if(description.trim().isEmpty) {
                    return 'Descrição é obrigatório';
                  }
                  
                  if(description.trim().length < 10) {
                    return 'Descrição precisa no mínimo de 10 letras';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da imagem'),
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      keyboardType: TextInputType.url,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
                      validator: (_imageUrl) {
                         final imageUrl = _imageUrl ?? '';
                          if(!isValidImageUrl(imageUrl)) {
                            return 'Informe uma URL válida!';
                          }
                            return null;
                        },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      )
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty 
                    ? Text('Informe a URL') 
                    : Container(
                      width: 100,
                      height: 100,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(_imageUrlController.text),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
          ),
      ),
    );
  }
}