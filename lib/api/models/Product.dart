class Product {
  final int id;
  final String name;
  final String classification;
  final double price;
  final String image;
  int count = 0;

  Product({
    this.id, 
    this.name,
    this.classification,
    this.price,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['text'],
      classification: json['categorias'],
      price: json['preciodefault'],
      image: json['imagen'],
    );
  }
}