import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String uid;
  final bool isme;


  MessageBubble(this.message,this.uid,this.isme);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isme?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(

          width: 140,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                  builder: (context,AsyncSnapshot snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: Text('Loading...'));
                    }
                    return Text(
                      snapshot.data['firstName'],style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                       //   fontWeight: FontWeight.bold
                    ),
                    );
                  },

                ),
                
                Text(message,style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isme?Colors.grey:Colors.deepPurpleAccent
          ),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
        ),
      ],
    );
  }
}
