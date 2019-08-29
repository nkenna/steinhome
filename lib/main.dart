import 'package:flutter/material.dart';
import 'package:steinhome/authscreens/login.dart';
import 'package:steinhome/authscreens/signup.dart';
import 'package:steinhome/customUI/custombutton.dart';
import 'package:steinhome/board.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
        '/login': (BuildContext context) => new LoginPage(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/board': (BuildContext context) => new BoardPage(),
        },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  



  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.email;
  }

  @override
  Widget build(BuildContext context) {
  
    



    return Scaffold(
      
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Hero(
                  tag: 'logo',
                  child: new Container(
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
            ),
             
                CustomButton(
                  callback: (){
                      Navigator.of(context).pushReplacementNamed('/login');
                  } ,
                  text: "Login",),
                CustomButton(
                  callback: (){
            
                      Navigator.of(context).pushReplacementNamed('/signup');
                  } ,
                  text: "SignUp",),

          ],
        ),
      ),
    
    );
  }
}

