class Area {
  final int id;
  final String name;
  final double price;

  Area({
    this.id,
    this.name,
    this.price
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['zonaid'],
      name: json['nombre'],
      price: json['precioenvio']
    );
  }
}