import 'package:flutter/material.dart';
import 'package:yegayega/api/models/Product.dart';

class ConfirmationDialog extends StatefulWidget{
  final List<Product> cartProducts; 
  final double totalCart;

  const ConfirmationDialog({Key key, this.cartProducts, this.totalCart}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConfirmationDialogState();
    
  }
}
    
class ConfirmationDialogState extends State<ConfirmationDialog>{
  Item selectedItem = users[0];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("CONFIRMAR PEDIDO"),
      content: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Nombre',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Teléfono',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.pin_drop),
              labelText: 'Dirección',
            ),
          ),
          DropdownButton<Item>(
            hint:  Text("Lugar - Costo de envío"),
            value: this.selectedItem,
            onChanged: (Item Value) {
              setState(() {
                this.selectedItem = Value;
              });
            },
            items: users.map((Item user) {
              return  DropdownMenuItem<Item>(
                value: user,
                child: Row(
                  children: <Widget>[
                    Text(
                      user.name + "  -  ",
                      style:  TextStyle(color: Colors.black),
                    ),
                    Text(
                      user.showPrice,
                      style:  TextStyle(color: Colors.black),
                    ),
                    
                  ],
                ),
              );
            }).toList(),
          ),
          Text("Detalle", textAlign: TextAlign.right, style:  TextStyle(height: 2, fontSize: 22)),
          for (var item in widget.cartProducts) 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 15.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: item.count.toString() + " " + item.name),
                ),
              ),
                Text("Q. " + (item.count * item.price).toString(), textAlign: TextAlign.right, style:  TextStyle(fontSize: 15))
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 15.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: "Costo de envío",)
                ),
              ),
                Text("Q. " + (selectedItem.price).toString(), textAlign: TextAlign.right, style:  TextStyle(fontSize: 15))
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 22.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: "Total a pagar",)
                ),
              ),
                Text("Q. " + ((widget.totalCart + selectedItem.price)).toString(), textAlign: TextAlign.right, style:  TextStyle(fontSize: 22))
              ]
            ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text(
            "REGRESAR",
            style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          ),
        ),
        FlatButton(
          onPressed: (){},
          child: Text(
            "CONFIRMAR",
            style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          ),
        )
      ]
      );
  }

}

class Item {
  const Item(this.name,this.price, this.showPrice);
  final String name;
  final double price;
  final String showPrice;
}


List<Item> users = <Item>[
    const Item('Santa María Ixhuatán',5, 'Q5.00'),
    const Item('Estanzuelas',8, 'Q8.00'),
    const Item('Santa Anita',8, 'Q8.00'),
    const Item('Los Hatillos',8, 'Q8.00'),
    const Item('La Esperanza',10, 'Q10.00'),
    const Item('La Fila',10, 'Q10.00'),
    const Item('Llano Grande',12, 'Q12.00'),
  ];