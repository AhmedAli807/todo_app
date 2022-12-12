import 'package:shared_preferences/shared_preferences.dart';
class PreferencesHelper{
  //class_name obj_name=instance();
  static final PreferencesHelper instance= PreferencesHelper._init();
  PreferencesHelper._init();

  final String isOpenedKey='is_Opened';
  SharedPreferences? _preferences;
   Future<void>init()async{
  _preferences=await SharedPreferences.getInstance();
  }
  bool getIsOpened(){
    return _preferences?.getBool(isOpenedKey)??false;
  }
   Future<void>setIsOpened(bool value)async{
    _preferences!.setBool(isOpenedKey,value );
  }
  Future<void>clearAllData()async{
    _preferences!.clear();
  }
   void clearItem(String key){
    _preferences!.remove(key);
  }


}