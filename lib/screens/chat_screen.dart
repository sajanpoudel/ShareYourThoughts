import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageData;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void messageStream() async {
  //   await for (var messageStreams
  //       in _firestore.collection('Messages').snapshots()) {
  //     for (var message in messageStreams.docs) {
  //       print(message.data);
  //     }
  //   }
  // }

  // void getMessages() async{
  //  var messages =  await _firestore.collection('Messages').get();
  //  for (var message in messages.docs) {
  //    print(message.data());

  //  }

  // }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                // try {
                //   await _auth.signOut();
                //   Navigator.pushNamed(context, WelcomeScreen.id);
                // } catch (e) {
                //   print(e);
                // }
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
            MessageBuild(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        if (value != null) {
                          messageData = value;
                        }
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      textEditingController.clear();
                      await _firestore.collection('Messages').add({
                        'text': messageData,
                        'Sender': loggedInUser.email,
                        "messageTime": DateTime.now(),
                      });
                      messageData = null;
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

class MessageBuild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Messages').orderBy('messageTime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }
          final messages = snapshot.data.docs;
          List<TextBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message['text'];

            final sender = message['Sender'];
            final currentUser = loggedInUser.email;
            if(messageText!=null){
 final messageWidget = TextBubble(
                sender: sender,
                messageText: messageText,
                isMe: currentUser == sender
                );
            messageWidgets.add(messageWidget);
            }
           
          }
          return Expanded(
              child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: messageWidgets,
          ));
        });
  }
}

class TextBubble extends StatelessWidget {
  TextBubble({this.messageText, this.sender, this.isMe});
  final String messageText;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            Material(
              shadowColor:
                  isMe? Colors.greenAccent : Colors.lightBlueAccent,
              elevation: 8.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
              color: isMe
                  ? Colors.lightGreenAccent[100]
                  : Colors.lightBlueAccent[100],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  messageText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ));
  }
}
