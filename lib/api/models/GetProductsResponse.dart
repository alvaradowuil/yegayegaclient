import 'package:yegayega/api/models/Product.dart';

class GetProductsResponse {
  final List<Product> data;

  GetProductsResponse({this.data});

  factory GetProductsResponse.fromJson(Map<String, dynamic> json) {
    List<Product> products = new List();

    if (json['items'] != null) {
      json['items'].forEach((product) => {
      products.add(Product(
        id: product['id'],
        name: product['text'],
        classification: product['categorias'],
        price: product['preciodefault'].toDouble(),
        image: product['imagen'],
      ))
      });
    }

    return GetProductsResponse(
        data: products);
  }
}