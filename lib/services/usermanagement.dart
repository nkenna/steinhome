
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(mobile, password, user, context) {
    Firestore.instance.collection('user').document()
  .setData({
      'email': user.user.email,
      'uid': user.user.uid,
      'password': password,
      'mobile': mobile
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/board');
    }).catchError((e) {
      print(e);
    });

  }
  
 /*  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'password': user.password,
      'name': user.name
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/intro');
    }).catchError((e) {
      print(e);
    });
  } */
}
