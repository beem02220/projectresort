import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'room.dart';

import 'room.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _color = '';

  TextEditingController nameText = TextEditingController();
  TextEditingController idcardText = TextEditingController();
  TextEditingController mobileText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: new Form(
            key: _formKey,
            child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    controller: nameText,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ชื่อ-สกุล',
                      labelText: 'ชื่อ-สกุล',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    validator: (value) {
                      if (value.isEmpty) return 'กรุณาระบุชื่อ';
                      return null;
                    },
                  ),
                  new TextFormField(
                    controller: mobileText,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'เบอร์โทร',
                      labelText: 'เบอร์โทร',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value.isEmpty) return 'กรุณาระบุเอบร์โทร';
                      return null;
                    },
                  ),
                  new TextFormField(
                    controller: idcardText,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.verified),
                      hintText: 'เลขบัตรประชาชน',
                      labelText: 'เลขบัตรประชาชน',
                    ),
                     keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                    validator: (value) {
                      if (value.isEmpty) return 'กรุณาระบุเลขบัตรประชาชน';
                      return null;
                    },
                  ),
                  Container(
                  
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text("ถัดไป"),
                      onPressed: () {
                          onSubmit();
                      },
                    ),
                  )
                ]))
 
        );

    
  }

    void onSubmit() {
        if (_formKey.currentState.validate()) {
           Map<String, dynamic> body2 = {
            'name': nameText.text,
            'mobile': mobileText.text,
            'idcard': idcardText.text,
          };
           Navigator.push(  context, MaterialPageRoute( builder: (context) => RoomPage(body: body2,)));
        }
      }
}
