import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'alldata.dart';
import 'getdata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  //To get a image

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final idCon = new TextEditingController();
  final passCon = new TextEditingController();
  CollectionReference imgref;
  firebase_storage.Reference ref;

  File userImage;

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      userImage = image;
    });
  }

  String imageLink;

  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = userImage.path;
  //   firebase_storage.Reference firebaseStorageRef = firebase_storage
  //       .FirebaseStorage.instance
  //       .ref()
  //       .child('uploads/$fileName');
  //   firebase_storage.UploadTask uploadTask =
  //       firebaseStorageRef.putFile(userImage);
  //   firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
  //   await taskSnapshot.ref.getDownloadURL().then(
  //         (value) => imageLink == value,
  //       );
  // }

  DocumentSnapshot data;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = userImage.path;
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads/${Path.basename(fileName)}');
    await ref.putFile(userImage).whenComplete(() async {
      ref.getDownloadURL().then((value) {
        imageLink = value;
      });
    });
    return imageLink;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgref = FirebaseFirestore.instance.collection('imageURls');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: idCon,
              decoration: InputDecoration(
                  //border: InputBorder.none,
                  hintText: 'ENTER YOUR ID',
                  prefixIcon: Icon(Icons.mail)),
            ),
            TextFormField(
              // obscureText: isHiddenPassWord,
              controller: passCon,
              decoration: InputDecoration(
                  //border: InputBorder.none,
                  hintText: 'ENTER YOUR PASSWORD',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    //   onTap: _togglePassWordView,
                    child: Icon(
                      Icons.visibility,
                    ),
                  )),
            ),
            Center(
              child: userImage == null
                  ? Text(
                      "UPLOAD PLACE IMAGE",
                      style: TextStyle(color: Colors.black54),
                    )
                  : Image.file(userImage),
            ),
            Builder(
              builder: (context) => FlatButton.icon(
                onPressed: () {
                  getImage();
                },
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.grey,
                ),
                label: Text(
                  "Add pic",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Builder(
              builder: (context) => FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  await uploadImageToFirebase(context);
                  print("upload done : $imageLink");
                },
                child: Text('upload'),
              ),
            ),
            Builder(
                builder: (context) => FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      uploadImageToFirebase(context);
                      Map<String, dynamic> data = {
                        "email": idCon.text,
                        "password": passCon.text,
                        "photo": imageLink,
                      };
                      FirebaseFirestore.instance.collection("test").add(data);
                      // FirebaseFirestore.instance
                      //     .collection("test")
                      //     .doc("text")
                      //     .update(data);
                    },
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    )))),
            Builder(
              builder: (context) => FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  DocumentSnapshot variable = await FirebaseFirestore.instance
                      .collection('test')
                      .doc('text')
                      .get();
                  print(variable['photo']);
                  data = variable;
                },
                child: Text('get data'),
              ),
            ),
            Builder(
              builder: (context) => FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => alldata()));
                },
                child: Text('ALL data'),
              ),
            ),
            Builder(
              builder: (context) => Column(
                children: [
                  Text(data['email']),
                  Text(data['password']),
                  Container(
                      child: Image(
                    image: NetworkImage(data['photo']),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
