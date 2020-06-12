import 'package:flutter/material.dart';
import 'package:yegayega/ActionsItem.dart';
import 'package:yegayega/api/models/Product.dart';
import 'package:yegayega/api/providers/products.provider.dart';
import 'package:yegayega/api/models/GetProductsResponse.dart';

import 'ConfirmationDialog.dart';
import 'api/ApiMethods.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextStyle greenStyle = TextStyle(color: Color.fromRGBO(0, 145, 86, 1));
  final TextStyle titleApp = TextStyle(color: Color.fromRGBO(0, 25, 81, 119));
  String cartButton = "Ver pedido";
  String productNotFount = "";

  TextEditingController searchController;
  bool _isSearchEnabled = true;

  List<Product> products = new List();
  List<Product> filterProducts = new List();

  bool submitting = false;
  String filter = '';
  bool isEmpty = false;
  int _itemCount = 0;
  double _totalCart = 0;
  bool isShowCart = false;

  Product productoToShow;

  @override
  void initState() {
    super.initState();

    this.searchController = new TextEditingController();

    this.getProducts();
    this.searchController.addListener(() {
      setState(() {
        filter = this.searchController.text;
        this.filterProducts = this
            .products
            .where((i) => i.name.toLowerCase().contains(filter.toLowerCase()))
            .toList();

        this.filterProducts.addAll(
          this.products
            .where((i) => i.classification.toLowerCase().contains(filter.toLowerCase()))
            .toList()
        );

        if (filter != '' && this.filterProducts.length == 0){
          productNotFount = 'Lo que buscas no existe en nuestro catálogo';
        } else {
          productNotFount = '';
        }
      });
    });
  }

  @override
  void dispose() {
    this.searchController.dispose();
    super.dispose();
  }

  _showResult(bool result){
    if (result) {
      setState(() {
        filterProducts = new List();
        submitting = false;
        _isSearchEnabled = true;
        filter = '';
        isEmpty = false;
        _itemCount = 0;
        _totalCart = 0;
      });
      this.getProducts();
    }
  }

  void _buildConfirmationDialog() {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return  ConfirmationDialog(
                cartProducts: this.products.where((product) => product.count > 0).toList(),
                totalCart: this._totalCart,
                onSendOrderListener: (result){
                  _showResult(result);
                },
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

  bool isFilterEmpty(){
    return this.filterProducts.length == 0 && filter == '';
  }

  _showCart(){
      searchController.text = '';
    setState(() {
      isShowCart = true;
      filter = '';
      _isSearchEnabled = false;
      filterProducts = this.products.where((product) => product.count > 0).toList();
      cartButton = "Ver todo";
    });
  }

  _showAll(){
    setState(() {
      isShowCart = false;
      this.filterProducts = new List();
      cartButton = "Ver pedido";
      _isSearchEnabled = true;
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
      if (_itemCount == 0) {
        filterProducts = new List();
      }
    });
  }

  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  String _value = "";
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _value = picked.toString());
  }

  @override
  Widget build(BuildContext context) {
    final searchTextField = TextField(
      enabled: _isSearchEnabled,
      decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Buscar",
          border: InputBorder.none),
      controller: this.searchController,
      autocorrect: false,
    );

    return Scaffold(
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset(
                 'assets/ic_launcher.png',
                  fit: BoxFit.contain,
                  height: 52,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('YegaYega',style: titleApp,))
            ],
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
                : Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      
                      this._itemCount < 1
                      ? Text("¿Qué quieres comprar?",
                      style: TextStyle(height: 5, fontSize: 25),
                      textAlign: TextAlign.center)
                      : Column(
                        children: <Widget>[

                          Text("Q. " + _totalCart.toString(),
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
                              isShowCart
                              ? _showAll()
                              : _showCart();
                            },
                            child: new Text(cartButton),),
                            new FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                                splashColor: Colors.blueAccent,
                                onPressed: () => _buildConfirmationDialog(),
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
                          Text(productNotFount),
                      _divider(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: !isFilterEmpty()
                            ? this.filterProducts.length
                            : this.products.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                    title: new Text(!isFilterEmpty()
                                              ? this.filterProducts[index].name
                                              : this.products[index].name),
                                    subtitle: new Text(!isFilterEmpty()
                                            ? 'Q. ' + this.filterProducts[index].price.toString()
                                            : 'Q. ' + this.products[index].price.toString()),
                                    leading: !isFilterEmpty()
                                            ? new Image.network(ApiMethods().getBaseImage() + this.filterProducts[index].image)
                                            : new Image.network(ApiMethods().getBaseImage() + this.products[index].image),
                                    trailing: ActionsItem(
                                      product: !isFilterEmpty()
                                              ? this.filterProducts[index]
                                              : this.products[index],
                                      addAction: _addItem,
                                      removeAction: _removeItem,
                                    ),
                                    //onTap: () {
                                    //  setState(() {
                                    //    this.productoToShow = !isFilterEmpty()
                                    //          ? this.filterProducts[index]
                                    //          : this.products[index];  
                                    //  });
                                    //},
                                ),
                              _divider()
                            ],
                          );
                        },
                      ))
                    ],
                  ),
                  if (this.productoToShow != null) 
                    Container(
                            color: Colors.white,
                            child: ListView(
                            children: <Widget>[
                              new Image.network(ApiMethods().getBaseImage() + this.productoToShow.image),
                              Text(this.productoToShow.name,
                                style: TextStyle(height: 2, fontSize: 20,), textAlign: TextAlign.center),
                              Text('Q ' + this.productoToShow.price.toString(),
                                style: TextStyle(height: 2, fontSize: 20), textAlign: TextAlign.center),
                              Text(this.productoToShow.name,
                                style: TextStyle(height: 2, fontSize: 15), textAlign: TextAlign.center),
                              Center(
                                child: Wrap(
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
                                        setState(() {
                                          this.productoToShow = null;  
                                        });
                                      },
                                      child: new Text("Regresar"))
                                  ,
                                  ActionsItem(
                                          product: this.productoToShow,
                                          addAction: _addItem,
                                          removeAction: _removeItem,
                                        )
                                  
                                ]
                              ),
                              )
                            ],
                          )
                        
                  )
                ],
              )
                
                );
  }
}

Widget _divider(){
  return Divider(
    height: 4,
    color: Color.fromRGBO(0, 145, 86, 1)
  );
}


