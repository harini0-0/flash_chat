import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
User loggedInUser;
var currentUser;
class ChatScreen extends StatefulWidget {
  static String id="chatbox";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getnewUser();
  }
  void getnewUser() async{

    final user = await _auth.currentUser;
    try{
      if(user !=null){
        loggedInUser =user;
        currentUser = loggedInUser.email;
        print(loggedInUser.email);
      }
      else print("no user");
    }
    catch(e){print(e);}
  }
  void messageStream() async{
    await for (var snapshots in _firestore.collection("messages").snapshots()){
      for(var messages in snapshots.docs){
        //print(messages.data());
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
                //messageStream();
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection("messages").add({
                        "texts": messageText,
                        "sender": loggedInUser.email,
                        'date and time': DateTime.now().toString(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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
class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(backgroundColor: Colors.blueAccent,));
        }
        final messages = snapshot.data.docs.reversed;
        //print(messages);
        List<MessageBubble> messageBubbles =[];
        for(var message in messages){
          final messageText = message.data()["texts"];
          final messageSender = message.data()["sender"];
          final messageDateTime = message.data()['date and time'];
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser==messageSender,
            dateTime: messageDateTime,
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a, b) =>
              DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
        }
        return Expanded(
          child: ListView(
            reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              children:messageBubbles
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender, this.isMe, this.dateTime});
  final String sender,text, dateTime;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: TextStyle(fontSize: 12.0, color: Colors.black54),),
          Material(
            borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):
            BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe? Colors.white: Colors.black54,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

