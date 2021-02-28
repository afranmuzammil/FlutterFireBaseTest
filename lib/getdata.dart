import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class getdata extends StatefulWidget {
  getdata({Key key}) : super(key: key);

  @override
  _getdataState createState() => _getdataState();
}

class _getdataState extends State<getdata> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot result;
    Future<DocumentSnapshot> getdata() async {
      DocumentSnapshot variable =
          await FirebaseFirestore.instance.collection('test').doc('text').get();
      print(variable['photo']);
      return result = variable;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('get Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(result['email']),
            Text(result['password']),
            Container(
                child: Image(
              image: NetworkImage(result['photo']),
            ))
          ],
        ),
      ),
    );
  }
}
