import 'package:authontication/model/users_model.dart';
import 'package:authontication/screen/login_screen.dart';
import 'package:authontication/screen/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel logeduser = UserModel();

  var _datamessage = '';

  final _messagecontroller = TextEditingController();

  @override
  void initState() {
    print(user!.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        this.logeduser = UserModel.fromMap(value.data());
      });
    });

    // TODO: implement initState
    super.initState();
  }

  void Signout() {
    FirebaseAuth.instance
        .signOut()
        .then((value) => Fluttertoast.showToast(msg: 'Logout successfully'));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _sendmessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    print('=============================' + user!.uid);
    FirebaseFirestore.instance
        .collection('/chats/MDThsbzzp7FX1rgq6NBj/messages')
        .add({
      'text': _datamessage,
      'CreatedAt': Timestamp.now(),
      'Userid': user.uid
    });
    _messagecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text(
            ' CSKchat',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(
                    // cardColor: Colors.red,
                    ),
                child: PopupMenuButton(itemBuilder: (BuildContext contex) {
                  return [
                    PopupMenuItem(
                        child: TextButton.icon(
                            onPressed: () {
                              Signout();
                            },
                            icon: Icon(Icons.logout),
                            label: Text('Logout'))),
                  ];
                }))
          ],
        ),
        body: Stack(
          children: [
            // Container(
            //     height: double.infinity,
            //     width: double.infinity,
            //     child: Image.network(
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9-1b1q-tS4k1bQoNHWr-x5T810IStmRCYBw&usqp=CAU',
            //       fit: BoxFit.fitWidth,
            //     )),
            Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot?>(
                        stream: FirebaseFirestore.instance
                            .collection('/chats/MDThsbzzp7FX1rgq6NBj/messages')
                            .orderBy('CreatedAt', descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          QuerySnapshot values = snapshot.data;

                          final document = values.docs;
                          return ListView.builder(
                              reverse: true,
                              itemCount: values.docs.length,
                              itemBuilder: (context, index) => MessageBubble(
                                  document[index]['text'],
                                  document[index]['Userid'],
                                  document[index]['Userid'] ==
                                      FirebaseAuth.instance.currentUser!.uid));
                        })),
                Card(
                    // elevation: 3,
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messagecontroller,
                        decoration: InputDecoration(
                            hintText: 'send message...',
                            hintStyle: TextStyle()),
                        onChanged: (value) {
                          setState(() {
                            _datamessage = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _sendmessage();
                        },
                        icon: Icon(Icons.send))
                  ],
                ))
              ],
            ),
          ],
        ));
  }
}
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         title: Text('Welcome'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/csklogo.png',
//               height: 200,
//               width: 200,
//             ),
//             Text(
//               'Welcome Back',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               logeduser.firstname.toString(),
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               logeduser.email.toString(),
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 Signout();
//               },
//               icon: Icon(
//                 Icons.logout,
//                 color: Colors.black,
//               ),
//               label: Text(
//                 'Log Out',
//                 style: TextStyle(color: Colors.black),
//               ),
//               style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
