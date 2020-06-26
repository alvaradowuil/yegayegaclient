final baseUrl = 'https://yegayega.com/api/';
final baseImage = 'https://yegayega.com/images/productos/';

class ApiMethods{

  getBaseUrl() {
    return baseUrl;
  }

  getBaseImage(){
    return baseImage;
  }

  getProducts() {
    return baseUrl + 'productosprecioventapedido/0?todos=1';
  }

  postOrder() {
    return baseUrl + 'guardarpedido';
  }

  getAreas() {
    return baseUrl + 'zonas';
  }
}