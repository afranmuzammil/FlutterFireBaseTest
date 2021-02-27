import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class alldata extends StatefulWidget {
  alldata({Key key}) : super(key: key);

  @override
  _alldataState createState() => _alldataState();
}

// ignore: camel_case_types
class _alldataState extends State<alldata> {
  // DocumentReference users =
  //     FirebaseFirestore.instance.collection('users').doc('ABC123');
  @override
  Widget build(BuildContext context) {
    // Stream documentStream =
    //     FirebaseFirestore.instance.collection('test').doc('text').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('All Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('test').snapshots(),
        //stream: documentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data.docs.map((document) {
              return Column(
                children: [
                  Text(document['email']),
                  Text(document['password']),
                  Container(
                      child: Image(
                    image: NetworkImage(document['photo']),
                  ))
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
