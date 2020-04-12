import 'package:flutter/material.dart';
import 'package:userslist/customize/loading_button.dart';
import 'package:userslist/model/post_users.dart';
import 'package:userslist/model/user_model.dart';
import 'package:userslist/providers/db_provider.dart';
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

  int _state = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          LoadingButon(
              state: _state,
              buttonName: 'SingleApi',
              onPressed: () async {
                setState(() {
                  _state = 1;
                });
                var save = await service.createPost();
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(save.id),
                  duration: Duration(seconds: 3),
                  
                ),
                
                );
                
               
                  setState(() {
                  _state = 2;
                });
               
              },
              
              ),

          RaisedButton(
            onPressed: () async {
              // var items=[0,1,2,3];
              for (int i = 0; i < 5; i++) {
                var save = await service.createPost();
                PersonDatabaseProvider.db.addPersonToDatabase(save);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(save.id),
                  duration: Duration(seconds: 3),
                ));
              }
            },
            child: Text('Multiple API'),
            color: Colors.red,
          ),

          //to print the value

          RaisedButton(
            onPressed: () async {
              // var items=[0,1,2,3];

              var users = await PersonDatabaseProvider.db.getAllPersons();

              for (var item in users) {
                print("Id:" +
                    item.id +
                    " ...." +
                    "Created At: " +
                    item.createdAt +
                    "\n");
              }
            },
            child: Text('Print API'),
            color: Colors.blue,
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
              }),
        ],
      ),
    );
  }
}
