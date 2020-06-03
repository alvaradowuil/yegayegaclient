import 'package:flutter/material.dart';
import 'package:yegayega/ActionsItem.dart';
import 'package:yegayega/api/models/Product.dart';
import 'package:yegayega/api/providers/products.provider.dart';
import 'package:yegayega/api/models/GetProductsResponse.dart';

import 'ConfirmationDialog.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextStyle greenStyle = TextStyle(color: Color.fromRGBO(0, 145, 86, 1));

  TextEditingController searchController = new TextEditingController();

  List<Product> products = new List();
  List<Product> filterProducts = new List();

  bool submitting = false;
  String filter = '';
  bool isEmpty = false;
  int _itemCount = 0;
  double _totalCart = 0;

  @override
  void initState() {
    super.initState();
    this.getProducts();
    this.searchController.addListener(() {
      setState(() {
        filter = this.searchController.text;
        this.filterProducts = this
            .products
            .where((i) => i.name.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    this.searchController.dispose();
    super.dispose();
  }

  void _buildConfirmationDialog() {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
                cartProducts: this.products.where((product) => product.count > 0).toList(),
                totalCart: this._totalCart
             );
    }
  );
}

  void showConnectionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Información"),
          content: new Text(
              "Ha habido un error de conexión, por favor vuelva a intentarlo."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> getProducts() async {
    this.toggleSubmitState();
    ProductProvider().getProducts((
        [bool response, GetProductsResponse responseData]) async {
      if (response) {
        if (responseData != null) {
          this.products = responseData.data as List<Product>;
        } else {
          this.isEmpty = true;
        }
      } else {
        if (responseData == null) {
          this.showConnectionAlert();
        }
      }
      this.toggleSubmitState();
    });
  }

  _showCart(){
    setState(() {
      filterProducts = this.products.where((product) => product.count > 0).toList();
    });
  }

  _showAll(){
    setState(() {
      this.filterProducts = new List();
    });
  }

  _actionItem(int idProduct, bool addItem){
    addItem ? _addItem(idProduct) : _removeItem(idProduct);
  }

  _addItem(int idProduct){
    int index = this.products.indexWhere((prod) => prod.id == idProduct);
    setState(() {
      _totalCart = _totalCart + this.products[index].price;
      products[index].count++;
      _itemCount++;
    });
  }

  _removeItem(int idProduct){
    int index = this.products.indexWhere((prod) => prod.id == idProduct);
    setState(() {
      _totalCart = _totalCart - this.products[index].price;
      products[index].count--;
      _itemCount--;
    });
  }

  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchTextField = TextField(
      decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Buscar",
          border: InputBorder.none),
      controller: this.searchController,
      autocorrect: false,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'YegaYega',
            style: greenStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Color.fromRGBO(0, 145, 86, 1)),
        ),
        backgroundColor: Colors.white,
        body: this.submitting
            ? const Center(child: const CircularProgressIndicator())
            : this.isEmpty
                ? Center(
                    child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(36.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  SizedBox(
                                    height: 125.0,
                                    child: Image.asset(
                                      "assets/emptyInformation.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                        height: 50,
                                        child: Container(
                                            child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Center(
                                              child: Text(
                                                  'No hay información disponible',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(0, 145, 86, 1),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    ),
                                                  textAlign: TextAlign.center
                                                  )),
                                        ))),
                                  ),
                                  SizedBox(height: 15.0),
                                ]))),
                  )
                : Column(
                    children: <Widget>[
                      
                      this._itemCount < 1
                      ? Text("¿Qué quieres comprar?",
                      style: TextStyle(height: 5, fontSize: 25),
                      textAlign: TextAlign.center)
                      : Column(
                        children: <Widget>[

                          Text("Q. " + _totalCart.toString() + ".00",
                          style: TextStyle(height: 2, fontSize: 35),),
                          Text(_itemCount.toString() + " Elementos",
                          style: TextStyle(height: 1, fontSize: 18),),
                          Wrap(
                            spacing: 8,
                            children: <Widget>[
                              new FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                            splashColor: Colors.blueAccent,
                            onPressed: () {
                              this.filterProducts.length > 0
                              ? _showAll()
                              : _showCart();
                            },
                        child: new Text("Ver pedido"),),
                        new FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                            splashColor: Colors.blueAccent,
                            onPressed: () {
                              _buildConfirmationDialog();
                            },
                        child: new Text("Comprar ahora"),)
                      
                            ]
                            
                          )

                        ]
                      ),
                      
                      
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Container(
                            child: SizedBox(
                                height: 50,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    0, 145, 86, 1)),
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Center(child: searchTextField),
                                        )))),
                          )),
                      _divider(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: this.filterProducts.length > 0
                            ? this.filterProducts.length
                            : this.products.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                    title: new Text(this.filter != ""
                                              ? this.filterProducts[index].name
                                              : this.products[index].name),
                                    subtitle: new Text(this.filter != ""
                                            ? 'Q. ' + this.filterProducts[index].price.toString() + '.00'
                                            : 'Q. ' + this.products[index].price.toString() + '.00' ),
                                    leading: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 44,
                                              minHeight: 44,
                                              maxWidth: 64,
                                              maxHeight: 64,
                                            ),
                                            //child: Image.network(
                                              //ApiMethods().getBaseImage() + this.products[index].image,fit: BoxFit.cover),
                                          ),
                                    trailing: ActionsItem(
                                      product: this.filter != ""
                                              ? this.filterProducts[index]
                                              : this.products[index],
                                      addAction: _addItem,
                                      removeAction: _removeItem,
                                    )
                                ),
                              _divider()
                            ],
                          );
                        },
                      ))
                    ],
                  ));
  }
}

Widget _divider(){
  return Divider(
    height: 4,
    color: Color.fromRGBO(0, 145, 86, 1)
  );
}


