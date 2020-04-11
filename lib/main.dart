import 'package:flutter/material.dart';
import 'package:userslist/model/postusers.dart';
import 'package:userslist/model/usermodel.dart';
import 'package:userslist/service/getusers.dart';

void main() {
  runApp(MyAPP());
}

class MyAPP extends StatefulWidget {
  @override
  _MyAPPState createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  GetService service = GetService();
  Users model = Users();
  PostUsers postUsers = PostUsers();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('list of details'),
        ),
        body: FutureBuilder<Users>(
            future: service.fetchservice(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? BearList(model: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class BearList extends StatefulWidget {
  final Users model;
  final PostUsers postUsers;
  BearList({this.model, this.postUsers});

  @override
  _BearListState createState() => _BearListState();
}

class _BearListState extends State<BearList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GetService service = GetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          RaisedButton(onPressed: () async {
          
          
            var save = await service.createPost();
            _scaffoldKey.currentState.showSnackBar(
              
                   SnackBar(
                      content: Text(save.id),
                      duration: Duration(seconds: 3),
                    )
                  
            );
          },
          child: Text('SingleAPI'),
          color: Colors.greenAccent,
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: widget.model.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.model.data[index].firstName +
                          ' ' +
                          widget.model.data[index].lastName,
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                );

//Text(widget.model.data[index].email);
              }),
        ],
      ),
    );
  }
}
