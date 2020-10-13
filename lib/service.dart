import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Service{
  
  static const String BASE_URL="https://mcu.getissue.com/demo/";
  static Future<List<Room>> getRooms() async {
    
    http.Response response = await http.get( BASE_URL+"api.php?action=getrooms");
    return  Room.allFromResponse(response.body,"result");
      
  }


   static Future<Room> onRegister(Map<String, dynamic> body) async {
   
      http.Response response = await http.post( 
        BASE_URL+"api.php?action=register",
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );
      return   Room.fromMap(json.decode(response.body));
       
  }


  static Future<void> setRoom(Room obj) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	prefs.setString("room", json.encode(obj));

  }
  static Future<Room> getRoom() async {
     Room room;
	   final SharedPreferences prefs = await SharedPreferences.getInstance();
     var map=prefs.getString("room");
     if(map!=null) {
          Map<String, dynamic> obj = json.decode(prefs.getString("room"));
          room =new Room();
          room.id=obj["id"] as int;
          room.registerId=obj["registerId"] as int;
          room.roomNo=obj["roomNo"] as String;
          room.secret=obj["secret"] as String;
     }
    
     return room;
  }

  static Future<void> signOut(body) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	prefs.remove("room");

    await http.post( 
        BASE_URL+"api.php?action=signout",
        body: body
      );
  }
}

class Room{
  int id;
  String roomNo;
  String secret;
  int registerId;
 
 
  Room({this.id, this.roomNo,this.secret, this.registerId});
 
  static List<Room> allFromResponse(String response,String key) {
    var decodedJson = json.decode(response).cast<String, dynamic>();
    return decodedJson[key]
        .cast<Map<String, dynamic>>()
        .map((obj) => Room.fromMap(obj))
        .toList()
        .cast<Room>();
  }
  
  static Room fromMap(Map map) {
    return new Room(
        id: (map['id'] != null ) ?  int.parse(  map['id']) : null,
        roomNo: map['room_no'] as String,
        secret: map['secret'] as String,
        registerId: (map['register_id'] != null ) ?  int.parse(  map['register_id']) : null,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "roomNo": this.roomNo,
      "registerId": this.registerId,
      "secret": this.secret,
    };
  }
}