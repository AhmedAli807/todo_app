import 'package:todo_app/constants.dart';

class InfoModel{
  int?id;
  String?name;
  String?email;
  String?phone;

  InfoModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });
 InfoModel.fromDB(Map<String,dynamic>data){
   id=data[columnID];
   name=data[columnName];
   phone=data[columnPhone];
   email=data[columnEmail];
 }
  Map<String,dynamic>toDB()=>{
   columnName:name,
    columnEmail:email,
    columnPhone:phone
  };
}