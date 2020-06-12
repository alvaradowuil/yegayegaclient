import 'package:yegayega/api/ApiMethods.dart';
import 'package:yegayega/api/models/GetProductsResponse.dart';
import 'package:yegayega/api/models/PostOrderRequest.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:yegayega/api/models/Product.dart';

class ProductProvider {

  Future<GetProductsResponse> getProducts(
    callback(bool response, GetProductsResponse responseData)) async {
      print('-*-*-*-*-*-*-*-*-*-*');

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(
            '${ApiMethods().getProducts()}');

        if (response.statusCode == 200) {
          callback(true, GetProductsResponse.fromJson(json.decode(response.body)));
        } else {
          callback(true, null);
        }
        
      }
    } on SocketException catch (_) {
      callback(false, null);
    }
  }

  Future<bool> postOrder(PostOrderRequest postOrderRequest, List<Product> products,
    callback(bool response)) async {

    List<Map> listProduct = new List();

    products.forEach((element) {
      Map map = new Map();
      map = {'productoid': element.id, 'cantidad': element.count.toString()};
      listProduct.add(map);
    });

    var now = new DateTime.now();
    //String formattedDate = DateFormat('yy mm dd').format(now);

    print('products ' + jsonEncode(listProduct));

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var request = new http.MultipartRequest('POST', Uri.parse(ApiMethods().postOrder()));
        request.headers[HttpHeaders.CONTENT_TYPE] = 'multipart/form-data;charset=utf-8';
        request.fields['telefono'] = postOrderRequest.telefono;
        request.fields['nombre'] = postOrderRequest.nombre;
        request.fields['direccion'] = postOrderRequest.direccion;
        request.fields['direccionentregaid'] = '0';
        request.fields['aliasdireccion'] = '';
        request.fields['fechaentrega'] = postOrderRequest.fechaentrega;
        request.fields['horaentrega'] = postOrderRequest.horaentrega + ":00";
        request.fields['indicacionesespeciales'] = postOrderRequest.indicacionesespeciales;
        request.fields['correo'] = '';
        request.fields['zonaid'] = postOrderRequest.zonaid.toString();
        request.fields['productos'] = jsonEncode(listProduct);

        final response = await request.send();

        print('*-*-*-*-*-*-*-*-*-*-*-*-*' + postOrderRequest.fechaentrega + '----' + postOrderRequest.horaentrega);
        
        response.stream.transform(utf8.decoder).listen((event) {
          print(event.toString());
        });

        if (response.statusCode == 200) {
          callback(true);
        } else {
          callback(false);
        }
        
      }
    } on SocketException catch (_) {
      callback(false);
    }
  }
}