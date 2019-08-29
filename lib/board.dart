import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:steinhome/thermometer_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import 'package:steinhome/customUI/custombutton.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class BoardPage extends StatefulWidget {
  


  
   FirebaseUser user;
  BoardPage({Key key, this.user}) : super(key: key);

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
 
  

  @override
initState() {
  super.initState();

  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
    checkNetwork();
    
  });
 // getCurrentUser();

  temperaturetimer();
}

// Be sure to cancel subscription after you are done
@override
dispose() {
  super.dispose();

  subscription.cancel();
}

/* String getCurrentUser() {
  String s = "zz";

    FirebaseAuth.instance.currentUser().then((user) {
      print(user.email);
      setState(() {
       s = user.email; 
      });

    }).catchError((e) {
      setState(() {
       s = "empty"; 
      });

    });
    
    
   return s;
  } */

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
  Timer.periodic(new Duration(minutes: 1), (timer){
    checkNetwork  ();
    retrieveTemperature();
    networkhumdity ();
    networkhumdity();
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

networktemp () async {
  
  var url = "http://192.168.0.104/stein/temp";

  // Await the http get response, then decode the json-formatted responce.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    
    print(response.body);
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

networkhumdity () async {
  
  var url = "http://192.168.0.104/stein/humd";

  // Await the http get response, then decode the json-formatted responce.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    
    print(response.body);
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

networktorch () async {
  
  var url = "http://192.168.0.104/stein/torch";

  // Await the http get response, then decode the json-formatted responce.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    
    print(response.body);
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

networkalarm () async {
  
  var url = "http://192.168.0.104/stein/alarm";

  // Await the http get response, then decode the json-formatted responce.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    
    print(response.body);
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
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
  return new Text("ccc" == null ? "not available" : "nkennannadi", style: new TextStyle(color: Colors.red, fontSize: 15.0));
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
          color: Colors.white,
       
        child: Center(
          child: new SizedBox(
      child: ThermometerWidget(
        borderColor: Colors.black26,
        innerColor: Colors.black26,
        indicatorColor: temperature > 28 ? Colors.red : Colors.green,
        temperature: temperature.toDouble(), // appMqtt.getTemperature(),
      )
    )
        )
        );
  }

  Widget humditybox(){
    return new Container(
      child: new CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 10.0,
                      percent: humdity/100.0,
                      center: new Text("$humdity %"),
                      progressColor: humdity < 50 || humdity > 68 ? Colors.red : Colors.green,
                    ),
    );
  }

  Widget sensorPanel(){
    return new Padding(
      padding: EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          sizebox(),
          humditybox()
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButton(
            callback: (){
            Navigator.of(context).pushReplacementNamed('/login');
            },
            text: "TORCH"
          ),

          CustomButton(
            callback: (){
            Navigator.of(context).pushReplacementNamed('/login');
            },
            text: "ALARM"
          ),

          CustomButton(
            callback: (){
            Navigator.of(context).pushReplacementNamed('/login');
            },
            text: "AUTO"
          ),
          
        ],
      ),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
  var width = screenSize.width;
  var height = screenSize.height;
   
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.red,
            onPressed: (){
              signout();
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Colors.red,
            onPressed: (){
              signout();
              Navigator.of(context).pushReplacementNamed('/home');
            },
          )
        ],
        backgroundColor: Colors.white,
        
        leading: Hero(
                  tag: 'logo',
                  child: new Container(
                    height: height,
                    width: 150.0,
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
      ),
      
      body: new Container(
        padding: new EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            tempContainer(),
            sensorPanel(),
            //sizebox(),
            lowpanel()
          ],
        ),
      )
    
    );
  }
}
