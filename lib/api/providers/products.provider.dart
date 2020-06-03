import 'package:yegayega/api/ApiMethods.dart';
import 'package:yegayega/api/models/GetProductsResponse.dart';
import 'package:yegayega/api/models/PostOrderRequest.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  Future<GetProductsResponse> postOrder(PostOrderRequest postOrderRequest,
    callback(bool response)) async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.post(
            ApiMethods().postOrder(),
            body: postOrderRequest.toJson()
        );

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