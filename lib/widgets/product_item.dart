import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Remover Produto'),
                    content: Text('Você quer realmente remover o produto?'),
                    actions: [
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    } catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                          ),
                        ),
                      );
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
