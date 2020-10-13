import 'package:flutter/material.dart';
import 'register.dart';
import 'service.dart';
class HomePage extends StatefulWidget {
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
 Room room;
 @override
  void initState() {
    super.initState();
    this.room=null;
    //_initial();
    Service.getRoom().then((data){
        setState(() {
            this.room=data;
        });
    });
    
  } 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        margin: EdgeInsets.only(top:120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
             Container(
               margin: EdgeInsets.only(top:60),
               child:  Text( 'RESTORE KEY', style: TextStyle(fontSize: 30),),
             ),
             
             (this.room!=null)?Container(
               margin: EdgeInsets.only(top:60),
               child: Text("Room No."+this.room.roomNo,style: TextStyle(fontSize: 30),),
             ):SizedBox(),
            (this.room!=null)?Container(
              margin: EdgeInsets.only(top:30),
               child: Text(this.room.secret,style: TextStyle(fontSize: 40),),
             ):SizedBox(),
            (this.room!=null)?Container(
               margin: EdgeInsets.only(top:60),
               padding: EdgeInsets.symmetric(horizontal: 20),
               width: double.infinity,
               child: RaisedButton
               (
                 textColor: Colors.white,
                 color: Colors.blue,
                 child: Text("คืนกุญแจ"),
                 onPressed: () {
                    Map<String, dynamic> body = {
                      'room_id': room.id.toString(),
                      'register_id': room.registerId.toString(),
                    };
                     Service.signOut(body);
                     setState(() {
                       this.room=null;
                     });
                 },
               ),
            ):Container(
               margin: EdgeInsets.only(top:200),
               padding: EdgeInsets.all(20),
               width: double.infinity,
               child: RaisedButton
               (
                 textColor: Colors.white,
                 color: Colors.blue,
                 child: Text("ลงทะเบีบน"),
                 onPressed: () {
                    Navigator.push( context,MaterialPageRoute(builder: (context) => RegisterPage()));
                 },
               ),
            ),
 
            
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
