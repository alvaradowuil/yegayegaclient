import 'package:flutter/material.dart';
import 'package:yegayega/api/models/PostOrderRequest.dart';
import 'package:yegayega/api/models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'api/models/Area.dart';
import 'api/providers/products.provider.dart';

class ConfirmationDialog extends StatefulWidget{
  final List<Product> cartProducts; 
  final double totalCart;
  final List<Area> areas;
  final ValueChanged<bool> onSendOrderListener;

  const ConfirmationDialog({Key key, this.cartProducts, this.totalCart, this.areas, this.onSendOrderListener}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConfirmationDialogState();
    
  }
}
    
class ConfirmationDialogState extends State<ConfirmationDialog>{
  bool submitting = false;
  Area selectedArea;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController indicationsController = new TextEditingController();
  DateTime dateTime = new DateTime.now();
  String dateToShow = "Ahora";

  Future<void> _getDataSaved() async {
    final prefs = await SharedPreferences.getInstance();

    this.nameController.text = prefs.getString("name");
    this.phoneController.text = prefs.getString("phone");
    this.addressController.text = prefs.getString("address");
    this.indicationsController.text = prefs.getString("indications");

    int zone = prefs.getInt("zone") ?? 1;
    setState(() {
      this.selectedArea = widget.areas.where((element) => element.id == zone).toList()[0];
    });
  }

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

  Future<Null> saveOrder() async {
    PostOrderRequest postOrderRequest = new PostOrderRequest(
      phoneController.text,
      nameController.text,
      addressController.text,
      selectedArea.id,
      indicationsController.text,
      DateFormat('yyyy-MM-dd').format(this.dateTime).toString(),
      DateFormat('kk:mm').format(this.dateTime).toString());

    ProductProvider().postOrder(postOrderRequest, widget.cartProducts, (
        [bool responseStatus, String message, bool responseData]) async {
          print('response -- ' + responseStatus.toString());
          widget.onSendOrderListener(responseStatus);
          setState(() {
            this.submitting = false;      
          });
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("YegaYega"),
              content: new Text(
                  message),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (responseStatus){
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
    );

      },
    );
  }

  @override
  void initState() {
    super.initState();

    this.nameController.text = "";
    this.phoneController.text = "";
    this.addressController.text = "";
    this.indicationsController.text = "";

    selectedArea = widget.areas[0];

    _getDataSaved();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("CONFIRMAR PEDIDO"),
      content: this.submitting
      ? const Center(child: const CircularProgressIndicator())
      : SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Nombre',
            ),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Teléfono',
            ),
          ),
          TextField(
            controller: addressController,
            maxLines: null,
            decoration: InputDecoration(
              icon: Icon(Icons.pin_drop),
              labelText: 'Dirección',
            ),
          ),
          TextField(
            controller: indicationsController,
            maxLines: null,
            decoration: InputDecoration(
              icon: Icon(Icons.message),
              labelText: 'Indicaciones especiales',
            ),
          ),
          DropdownButton<Area>(
            value: this.selectedArea,
            onChanged: (Area area) async {
              setState(() {
                this.selectedArea = area;
              });
            },
            items: widget.areas.map((Area area) {
              return  DropdownMenuItem<Area>(
                value: area,
                child: Text(
                        area.name + "  -  Q" + area.price.toString(),
                        style:  TextStyle(color: Colors.black),
                      ),
              );
            }).toList(),
          ),
          Text("Fecha de entrega", textAlign: TextAlign.left, style:  TextStyle(height: 2, fontSize: 16)),
          RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 2.0,
                onPressed: () async {
                  final dTime = await showDatePicker(
                    context: context, 
                    initialDate: new DateTime.now(), 
                    firstDate: new DateTime.now(), 
                    lastDate: new DateTime(2025),
                    locale: const Locale('es','ES')
                  );
                  if (dTime != null){
                    final TimeOfDay tOfDay = await showTimePicker(
                    context: context,
                    initialTime: new TimeOfDay.now());
                  setState(() {
                    this.dateTime = new DateTime(dTime.year, dTime.month, dTime.day, tOfDay.hour, tOfDay.minute);
                    dateToShow = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
                  });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  dateToShow,
                                  style: TextStyle(
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Cambiar",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
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
                Text("Q. " + (selectedArea.price).toString(), textAlign: TextAlign.right, style:  TextStyle(fontSize: 15))
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
                Text("Q. " + ((widget.totalCart + selectedArea.price)).toString(), textAlign: TextAlign.right, style:  TextStyle(fontSize: 22))
              ]
            ),
        ],
      )),
      actions: <Widget>[
        FlatButton(
          onPressed: this.submitting ? null : () {
            Navigator.of(context).pop();
          },
          child: Text(
            "REGRESAR",
            style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          ),
        ),
        FlatButton(
          
          onPressed: this.submitting ? null : () async {
            if (this.nameController.text == '' || this.phoneController.text == '' || this.addressController.text == ''){
              showDialogEmptyFields();
            } else {
              setState(() {
                this.submitting = true;
              });
              final prefs = await SharedPreferences.getInstance();
                  prefs.setString('name', this.nameController.text);
                  prefs.setString('phone', this.phoneController.text);
                  prefs.setString('address', this.addressController.text);
                  prefs.setString('indications', indicationsController.text);
                  prefs.setInt('zone', this.selectedArea.id);
                  saveOrder();
            }
          },
          child: Text(
            "CONFIRMAR",
            style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          ),
        )
      ]
      );
  }

}