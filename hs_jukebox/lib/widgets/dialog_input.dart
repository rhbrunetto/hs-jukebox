import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget{
  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog>{
  String result;

  @override
  Widget build(BuildContext context) {
    return new Form(
        child: new Builder(
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('Add music URL'),
              content: TextField(
                onChanged: (text) => result = text,
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('CANCEL'),
                ),
                new FlatButton(
                  onPressed: () {
                    Form.of(context).save();
                    Navigator.of(context).pop(result);
                  },
                  child: new Text('SEND'),
                ),
              ],
            );
          }
        ),
    );
  }
}