import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:steinhome/thermometer_widget.dart';

import 'package:firebase_auth/firebase_auth.dart'; 


class BoardPage extends StatefulWidget {
  BoardPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  BoardPageState createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {

  StreamSubscription subscription;
  String wifiname = "xx";
  String wifiip = "xx";
  String wifiBSSID = "xx";

  int temperature = 0;
  int humdity = 0;
  FirebaseUser user;
  

  @override
initState() {
  super.initState();

  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
    checkNetwork();
    
  });
  getCurrentUser();

  temperaturetimer();
}

// Be sure to cancel subscription after you are done
@override
dispose() {
  super.dispose();

  subscription.cancel();
}

String getCurrentUser() {
  String s = "zz";

    FirebaseAuth.instance.currentUser().then((user) {
      print(user);
      setState(() {
       s = user.email; 
      });

    }).catchError((e) {
      setState(() {
       s = e.toString(); 
      });

    });
    
    
   return s;
  }

Future<void> signout() async {
  return FirebaseAuth.instance.signOut();
} 
  

void checkNetwork  ()async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    //wifiip = await (Connectivity().getWifiIP());
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    //var wifiBSSID = await (Connectivity().getWifiBSSID());
    setState(() {
     // wifiip = await (Connectivity().getWifiIP());
    //wifiname = await (Connectivity().getWifiName());
    });

    wifiip = await (Connectivity().getWifiIP());
    wifiname = await (Connectivity().getWifiName());
    wifiBSSID = await (Connectivity().getWifiBSSID());
    
  }
}


void temperaturetimer(){
  Timer.periodic(new Duration(minutes: 5), (timer){
    retrieveTemperature();
  });
}

retrieveTemperature (){
  var num = new Random();
  print(num.nextInt(40));
  setState(() {
    temperature = num.nextInt(40);
    humdity = num.nextInt(100);
  });
}

Widget networkbssidext(){
  return new Text(wifiBSSID, style: new TextStyle(color: Colors.red, fontSize: 15.0));
}

Widget humditytext(){
  return new Text("humdity: $humdity %", style: new TextStyle(color: Colors.red, fontSize: 15.0));
}

Widget networknametext(){
  return new Text(wifiname == null ? "not available" : wifiname, style: new TextStyle(color: Colors.red, fontSize: 15.0));
}

Widget networkiptext(){
  return new Text(wifiip == null ? "not available" : wifiip, style: new TextStyle(color: Colors.red, fontSize: 15.0));
}

Widget usertext(){
  return new Text(getCurrentUser() == null ? "not available" : getCurrentUser(), style: new TextStyle(color: Colors.red, fontSize: 15.0));
}

Widget networkRow(){
  return new Padding(
    padding: EdgeInsets.all(2.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        networknametext(),
        networkiptext()
      ],
    ),
  );
}

Widget tempContainer(){
  return new Padding(
    padding: EdgeInsets.all(2.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        networknametext(),
        networkiptext(),
        //networkbssidext(),
        humditytext(),
        usertext()
      ],
    ),
  );
}

Widget sizebox(){
  var screenSize = MediaQuery.of(context).size;
  var width = screenSize.width;
  var height = screenSize.height;
  
  
    return new Container(
          color: Colors.black,
        width: width,
        height: 200,
        child: Center(
          child: new SizedBox(
      child: ThermometerWidget(
        borderColor: Colors.amber,
        innerColor: Colors.yellow,
        indicatorColor: Colors.red,
        temperature: temperature.toDouble(), // appMqtt.getTemperature(),
      )
    )
        )
        );
  }

Widget lowpanel(){
  return new Padding(
    padding: EdgeInsets.only(top: 30.0),
    child: new Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
    rightpane(),
    leftpane()
  ],),
  );
}

Widget rightpane(){
  var screenSize = MediaQuery.of(context).size;
  var width = screenSize.width;
  var height = screenSize.height;

  return new Container(
    color: Colors.white30,
    width: (width/2) - 10,
    height: 320,
    child: new Center(
      child: buttonscolumn()
    ),

  );
}

Widget leftpane(){
  var screenSize = MediaQuery.of(context).size;
  var width = screenSize.width;
  var height = screenSize.height;

  return new Container(
    color: Colors.amber,
    width: (width/2) - 10,
    height: 320,
    child: new Center(
      child: new Text('yyyy'),
    ),

  );
}

Widget signoututton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: new RaisedButton(
        color: Colors.green,
        onPressed: (){
          signout();
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: new Text("SIGNOUT", style: new TextStyle(color: Colors.white),),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
      )
    );
  }

Widget alarmbutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: new RaisedButton(
        color: Colors.green,
        onPressed: (){
          
        },
        child: new Text("ALARM", style: new TextStyle(color: Colors.white),),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
      )
    );
  }

Widget autobutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: new RaisedButton(
        color: Colors.green,
        onPressed: (){
          
        },
        child: new Text("AUTO", style: new TextStyle(color: Colors.white),),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
      )
    );
  }


  Widget lightbutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: new RaisedButton(
        color: Colors.green,
        onPressed: (){
          
        },
        child: new Text("TORCH", style: new TextStyle(color: Colors.white)),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
    );
  }

  

  Widget buttonscolumn(){
    return new Padding(
      padding: EdgeInsets.all(5.0),
      child: new Column(
        children: <Widget>[
          lightbutton(),
          alarmbutton(),
          autobutton(),
          signoututton()
        ],
      ),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: new Container(
        padding: new EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            tempContainer(),
            sizebox(),
            lowpanel()
          ],
        ),
      )
    
    );
  }
}
