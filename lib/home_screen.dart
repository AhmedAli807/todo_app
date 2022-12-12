import 'package:flutter/material.dart';
import 'package:todo_app/data_base_helper.dart';
import 'package:todo_app/preferences_helper.dart';

import 'info_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InfoModel> data = [];

  Future<List<InfoModel>> getData() async {
    data = await DatabaseHelper.instance.readAllInfo();
    print('Data : ${data.length}');
    return data;
  }



  // Future<InfoModel>

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (PreferencesHelper.instance.getIsOpened() == false) {
        welcomeAlert();
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          topBar(),
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) => snapshot.hasData
                ? dataList(data)
                : snapshot.hasError
                    ? const Text('Sorry something went wrong',
            style: TextStyle(
              color: Colors.white
            ),)
                    : const CircularProgressIndicator(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlert();
        },
        child: Icon(Icons.add),

      ),
    );
  }

  Widget topBar() => Container(
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        child: SafeArea(
            child: Column(
          children: [
            Text(
              'Welcome in Note App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
              color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text('you can store any note  ',
            style: TextStyle(
              color: Colors.white
            ),),
          ],
        )),
        height: 200,
        width: double.infinity,
      );

  Widget dataList(List<InfoModel> noteList) => noteList.isEmpty
      ? const Text('No Data Found',
  style: TextStyle(
    color: Colors.white
  ),
  )
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: noteList.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => ListTile(
                  title: Text('Name: ${noteList[index].name}',
                  style: TextStyle(
                    color: Colors.white
                  ),),

                  subtitle: Text('phone: ${noteList[index].phone}',
                  style: TextStyle(
                    color: Colors.grey
                  ),),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[400],
                    child: Text(
                      (noteList[index].name ?? '') != ''
                          ? noteList[index].name!.substring(0, 2).toUpperCase()
                          : '',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
      );

  void showAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF050522),
              title: Text(
                'Add User',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
              content: Wrap(
                children: [
                  Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent
                        ),
                        child: TextFormField(
                          decoration: fieldDecoration('name'),
                          controller: nameController,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent
                        ),
                        child: TextFormField(
                          decoration: fieldDecoration('phone'),
                          controller: phoneController,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent
                        ),
                        child: TextFormField(
                          decoration: fieldDecoration('Email'),
                          controller: emailController,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    DatabaseHelper.instance
                        .insertInfo(InfoModel(
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text))
                        .then((value) {
                      getData();
                      setState(() {});
                    }).whenComplete(() {
                      Navigator.pop(context);
                      nameController.clear();
                      phoneController.clear();
                      emailController.clear();
                    });
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(primary: Colors.indigo),
                )
              ],
            ));
  }

  void welcomeAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(
                'Welcome in Note App',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal[800]),
              ),

              actions: [
                ElevatedButton(
                  onPressed: () {
                    PreferencesHelper.instance.setIsOpened(true);
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                )
              ],
            ));
  }


  InputDecoration fieldDecoration(String hint) =>
      InputDecoration(hintText: hint, border: OutlineInputBorder());
}
