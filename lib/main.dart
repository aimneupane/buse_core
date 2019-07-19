import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' show get;

import 'dart:convert';


class Space{
  final String id;
  final String name,imageUrl,propellent;
  Space({
    this.id,
    this.name,
    this.imageUrl,
    this.propellent,
});

  factory Space.fromJson(Map<String,dynamic> jsonData){
    return Space(
      id: jsonData['id'],
      name: jsonData['name'],
      imageUrl: "http://192.168.1.11/PHP/space/images/"+jsonData['image_url'],
      propellent: jsonData['propellent'],

    );
  }

}


class CustomListView extends StatelessWidget {
  final List<Space> space;
  CustomListView(this.space);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: space.length,
        itemBuilder: (context,int currentIndex){
          return createViewItem(space[currentIndex],context);
        },
    );
  }

  Widget createViewItem(Space space, BuildContext context) {

    return ListTile(
      title: Card(
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange)
          ),

          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                child: Image.network(space.imageUrl),
                padding: EdgeInsets.only(bottom: 8.0),

              ),

              Row(
                children: <Widget>[
                  Padding(
                    child: Text(
                      space.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,

                    ),
                    padding: EdgeInsets.all(1.0),
                  ),


                  Text(" | "),

                  Padding(
                    child: Text(
                      space.propellent,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,

                      ),
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.all(1.0),
                  )




                ],
              ),


            ],
          ),

        ),
      ),

      onTap: (){
        var route=MaterialPageRoute(builder:(BuildContext context)=>SecondScreen(value:space),);
        Navigator.of(context).push(route);
      }
    );



  }

}


Future<List<Space>> downloadJSON() async{
  final jsonEndPoint="http://192.168.1.11/PHP/space";
  final response=await get(jsonEndPoint);
  if(response.statusCode==200)
    {
      List space=json.decode(response.body);
      return space.map((space)=>Space.fromJson(space)).toList();
    }
  else
    {
      throw Exception('we are not able to download the json data');
    }
}




//for second screen

class SecondScreen extends StatefulWidget {
  final Space value;
  SecondScreen({Key key,this.value}):super(key:key);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("detail page"),
      ),


      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: Text(
                  "space Details",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                  textAlign: TextAlign.center,

                ),
                padding: EdgeInsets.only(bottom: 20.0),

              ),

              Padding(
                child: Image.network('${widget.value.imageUrl}'),
                padding: EdgeInsets.all(12.0),

              ),

              Padding(
                child: Text(
                  'Name:${widget.value.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),

              Padding(
                child: Text(
                  'Propellent:${widget.value.propellent}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),


            ],
          ),
        ),
      ),

    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'my sql images text'
          ),
        ),


        body: Center(
          child: FutureBuilder<List<Space>>(
            future: downloadJSON(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                List<Space> space=snapshot.data;
                return CustomListView(space);
              }
              else if(snapshot.hasError)
                {
                  return Text('${snapshot.error}');
                }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}


void main()=>runApp(MyApp());




