
import 'package:flutter/material.dart';

import 'api/models/Product.dart';

class ActionsItem extends StatefulWidget {
  final Product product;

  final ValueChanged<int> addAction;
  final ValueChanged<int> removeAction;

  const ActionsItem({Key key, this.product, this.addAction, this.removeAction}) : super(key: key);

  @override
  ActionsItemState createState() => ActionsItemState();
}


class ActionsItemState extends State<ActionsItem> {

  @override
  Widget build(BuildContext context) {
    return widget.product.count < 1 
                                              ? new FlatButton(
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                disabledColor: Colors.grey,
                                                disabledTextColor: Colors.black,
                                                padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                                                splashColor: Colors.blueAccent,
                                                onPressed: () {
                                                  widget.addAction(widget.product.id);
                                                },
                                                child: new Text("Comprar"),)
                                              : Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(45.0) //                 <--- border radius here
                                                  ),
                                                  color: Colors.blue,
                                                ),
                                                height: 40.0,
                                                child: Wrap(
                                                spacing: 1,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    color: Colors.white, 
                                                    onPressed: (){
                                                      widget.removeAction(widget.product.id);
                                                    },
                                                  ),
                                                  Container(
                                                    margin: new EdgeInsets.symmetric(vertical: 10.0),
                                                      color: Colors.white,
                                                      width: 30.0,
                                                      height: 20.0,
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          //this.products[index].count.toString(),
                                                          widget.product.count.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 35, color: Colors.blue),
                                                          ),
                                                      )),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    color: Colors.white, 
                                                    onPressed: (){
                                                      widget.addAction(widget.product.id);
                                                    },
                                                  ),
                                                ],
                                              )
                                              );




      
  }
}