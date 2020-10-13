import 'package:flutter/material.dart';
import 'service.dart';
import 'home.dart';
class RoomPage extends StatefulWidget {
  final Map<String, dynamic> body;
 
  const RoomPage({Key key, this.body}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Future<List<Room>> roomList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เลือกห้อง"),
      ),
     body:FutureBuilder<List<Room>>(
        future: Service.getRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? buildWidget(snapshot.data)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildWidget(List<Room> dataList) {
   return  new GridView.count(
        crossAxisCount: 3,
        
        children: List.generate(dataList.length, (index) {
          return InkWell(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                color:( dataList[index].registerId!=null)? Colors.grey[200]:Colors.lightGreen,
                child: Text(
                  
                  dataList[index].roomNo,
                  style: TextStyle(
                    fontSize: 30,
                    color: ( dataList[index].registerId!=null)? Colors.grey:Colors.black,
                    ),
                ),
              ),
              onTap: () {
                if (dataList[index].registerId==null) showAlertDialog(context,dataList[index]);
              },
          );
        }),
      );
  }
  showAlertDialog(BuildContext context,Room room) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("ยืนยัน"),
        onPressed: () { 
           
           Navigator.of(context).pop();
           onSubmit(room.id);
        },
      );
      Widget cancelButton = FlatButton(
        child: Text("ยกเลิก"),
        onPressed: () { 
           Navigator.of(context).pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("ข้อความ"),
        content: Text("คุณต้องการที่จะเบิกกุญแจห้อง "+room.roomNo+" ใช่หรือไม่"),
        actions: [
          okButton,
          cancelButton
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    void  onSubmit(int roomId) {

        widget.body["room_id"]=roomId.toString();
        // ["room_id"]=roomId.toString();

        Service.onRegister(widget.body).then((response) {
            Service.setRoom(response);
            Navigator.pushReplacement( context,MaterialPageRoute(builder: (context) => HomePage()));
        }).catchError((onError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(onError.toString()),
            ));
        });
    }
 // Widget buildWidget()
}