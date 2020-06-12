class PostOrderRequest {
  String telefono;
  String nombre;
  String direccion;
  String direccionentregaid;
  String aliasdireccion;
  String fechaentrega;
  String horaentrega;
  String indicacionesespeciales;
  String correo;
  int zonaid;
  //List<Product> productos;

  PostOrderRequest(
    this.telefono, 
    this.nombre,
    this.direccion,
    this.zonaid,
    this.indicacionesespeciales,
    this.fechaentrega,
    this.horaentrega
    );

  Map<String, dynamic> toJson() =>
    {
      'telefono': telefono,
      'nombre': nombre,
      'direccion': direccion,
      //'direccionentregaid': direccionentregaid,
      //'aliasdireccion': aliasdireccion,
      'fechaentrega': fechaentrega,
      'horaentrega': horaentrega,
      'indicacionesespeciales': indicacionesespeciales,
      //'correo': correo,
      'zonaid': zonaid
    };

}