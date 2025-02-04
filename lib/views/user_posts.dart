import 'package:flutter/material.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/repositories/posts_repository.dart';
import 'package:unishop/views/new_post.dart';
//import 'dart:typed_data'; useful for Image.memory

class UserPostsView extends StatefulWidget {
  const UserPostsView({super.key});

  @override
  State<UserPostsView> createState() {
    return _UserPostsViewState();
  }
}

class _UserPostsViewState extends State<UserPostsView> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await PostsRepository.loadProducts();
    setState(() {
      _products = loadedProducts;
    });
  }

  void _addProduct() async {
    final newProduct = await Navigator.of(context).push<Product>(
      MaterialPageRoute(
        builder: (ctx) => const NewPostView(),
      ),
    );

    if (newProduct == null) {
      return;
    }

    setState(() {
      _products.add(newProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Try adding a post',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );

    if (_products.isNotEmpty) {
      content = ListView.builder(
        itemCount: _products.length,
        itemBuilder: (ctx, index) => Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: Column(
            children: [
              //Image.memory(Uint8List.fromList(_products[index].image.codeUnits)), Will be used once image is stored as bytes
              Image.network(_products[index].image.first),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    _products[index].title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Publications'),
        actions: [
          IconButton(
            onPressed: _addProduct,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
