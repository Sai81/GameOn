import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_on/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  static const String route = '/chat';
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String newMessage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch(e){
      print(e);
    }
  }

  void postsStream() async {
    await for(var snapshot in _firestore.collection('posts').snapshots()){
      for(var message in snapshot.docs){
        print(message.data);
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('posts').snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                child : CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
                )
                );
                }
              final posts = snapshot.data!.docs;
              List<Text> postWidgets = [];
              for(var post in posts){
                final postText = post['text'];
                final postSender = post['sender'];
                final postWidget = Text(
                  '$postText from $postSender',
                   style: TextStyle(
                      color: Colors.white,
                    ),
                );
                postWidgets.add(postWidget);
              }
              return Column(
                children: postWidgets,
              );
            },
            ),
            Container(
              decoration: PostContainer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        newMessage = value;
                      },
                      decoration: PostTextField,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      _firestore.collection('posts').add({
                        'text': newMessage,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: SendButton,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}