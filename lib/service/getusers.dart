
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:userslist/model/post_users.dart';
import 'package:userslist/model/user_model.dart';


class GetService{
Future<Users>  fetchservice() async {
  final String url = "https://reqres.in/api/users";
  final response = await http.get(url);
      final int statusCode = response.statusCode;
  if (statusCode < 200 || statusCode > 400 || json == null) {
      throw  Exception("Error while fetching data");
    }
return Users.fromJson(jsonDecode(response.body.toString()));

}

Future<PostUsers> createPost() async {
  final String url = "https://reqres.in/api/users";
  final response = await http.post(url);
  final int statuscode = response.statusCode;
  if(statuscode <200 || statuscode > 400 || json ==null)

{
  throw Exception("error");
}
return PostUsers.fromJson(jsonDecode(response.body.toString()));


  }

}

  


  
