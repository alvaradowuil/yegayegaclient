import 'package:flutter/material.dart';
import 'package:yegayega/api/models/Product.dart';

import 'ActionsItem.dart';
import 'api/ApiMethods.dart';

class ProductDetail extends StatefulWidget{
  final Product product; 
  final double totalCart;
  //final ValueChanged<bool> onSendOrderListener;

  const ProductDetail({Key key, this.product, this.totalCart}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductDetailState();
    
  }
}
    
class ProductDetailState extends State<ProductDetail>{
  final TextStyle titleApp = TextStyle(color: Color.fromRGBO(0, 25, 81, 119));
  showDialogEmptyFields(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("YegaYega"),
          content: new Text(
              "Todos los campos son requeridos"),
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

  @override
  void initState() {
    super.initState();
  }

   _addItem(int idProduct){
    setState(() {
      //_totalCart = _totalCart + widget.product.price;
      widget.product.count++;
    });
  }

  _removeItem(int idProduct){
    setState(() {
      //_totalCart = _totalCart - widget.product.price;
      widget.product.count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.white,
          child: ListView(
          children: <Widget>[
            Hero(tag:widget.product.id.toString(), child: new Image.network(ApiMethods().getBaseImage() + widget.product.image)),
            Text(widget.product.name,
              style: TextStyle(height: 2, fontSize: 20,), textAlign: TextAlign.center),
            Text('Q ' + widget.product.price.toString(),
              style: TextStyle(height: 2, fontSize: 20), textAlign: TextAlign.center),
            Text(widget.product.name,
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
                        //this.productoToShow = null;  
                      });
                    },
                    child: new Text("Regresar"))
                ,
                ActionsItem(
                        product: widget.product,
                        addAction: _addItem,
                        removeAction: _removeItem,
                      )
              ]
            ),
            )
          ],
        )
    )
    );
  }
}
