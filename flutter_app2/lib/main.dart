import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'httpUtil.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT',
      home: Scaffold(
          appBar: AppBar(
            title: Text('登录'),
          ),
          body: Center(
            child: LoginPage(),
          )),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _pwdEditController;
  TextEditingController _userNameEditController;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _pwdEditController = TextEditingController();
    _userNameEditController = TextEditingController();
    _pwdEditController.addListener(() => setState(() => {}));
    _userNameEditController.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTopBannerWidget(),
            Divider(height: 10.0),
            _buildEditWidget(),
            _buildLoginRegisterButton(),
            Divider(
              height: 10.0,
              color: Colors.black12,
            ),
            _buildJMTButton()
          ],
        ),
      ),
    );
  }

  _buildTopBannerWidget() {
    return Container(
      child: Image.asset(
        "images/login.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  _buildEditWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            width: 1.0 / MediaQuery.of(context).devicePixelRatio,
            color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        children: <Widget>[
          _buildLoginNameTextField(),
          Divider(height: 1.0),
          _buildPwdTextField(),
        ],
      ),
    );
  }

  _buildLoginNameTextField() {
    return TextField(
      controller: _userNameEditController,
      focusNode: _userNameFocusNode,
      decoration: InputDecoration(
        hintText: "用户名",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.accessibility_new),
      ),
    );
  }

  _buildPwdTextField() {
    return TextField(
      controller: _pwdEditController,
      focusNode: _pwdFocusNode,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "密码",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.border_color),
      ),
    );
  }

  _buildLoginRegisterButton() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: FlatButton(
                  onPressed: () {
                    _login();
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.green, fontSize: 20.0),
                  )),
            ),
          ),
          SizedBox(width: 15.0),
          Expanded(
              child: Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(width: 1.0, color: Colors.green),
            ),
            child: FlatButton(
                onPressed: () {
                  _register();
                },
                child: Text(
                  "注册",
                  style: TextStyle(color: Colors.green, fontSize: 20.0),
                )),
          ))
        ],
      ),
    );
  }

  _buildJMTButton() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: FlatButton(
                  onPressed: () {
                    _loginMicro();
                  },
                  child: Text(
                    "登录微服务",
                    style: TextStyle(color: Colors.green, fontSize: 20.0),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _loginMicro(){

    //TODO 网络请求
    Future fun() async{
      var response=await HttpUtil().get(Api.LOG_MICRO);
      return response;
    }

    fun().then((value){
      var code= jsonDecode(value.toString());
      var result = code['message'];
      //var jwt=code['data'];
      print(result);
      if(result=="Login Successful!") {
        Fluttertoast.showToast(
            msg: "登录微服务成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            //展示时长，仅IOS有效
            backgroundColor: Colors.black26,
            textColor: Colors.black,
            fontSize: 20.0
        );
      }
    });

  }


  _login() {
    var username = _userNameEditController.text;
    var password = _pwdEditController.text;

    if (username.length == 0) {
      /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('请输入用户名'),
              ));*/
      Fluttertoast.showToast(
          msg: "请输入用户名",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,//展示时长，仅IOS有效
        backgroundColor: Colors.black26,
        textColor: Colors.black,
        fontSize: 20.0
      );
    } else if (password.length == 0) {
      Fluttertoast.showToast(
          msg: "请输入密码",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );
    } else {
      //TODO 网络请求


     /* Future fun() async{
        var response=await HttpUtil().post(Api.LOGIN,data: {
          "username":username,
          "password":password
        });

        return response;
      }*/
      
      var data={
        "username":username,
        "password":password
      };


      _postH(data).then((value){

        var c= jsonDecode(value.toString());
        var jwt = c['data'];

        Future<dynamic> future = Future(()async{
          SharedPreferences prefs =await SharedPreferences.getInstance();
          prefs.setString("jwt", jwt);
        });

        var code= jsonDecode(value.toString());
        var result = code['message'];
        //var jwt=code['data'];
        //print(jwt);
        if(result=="login success") {
          Fluttertoast.showToast(
              msg: "登录成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              //展示时长，仅IOS有效
              backgroundColor: Colors.black26,
              textColor: Colors.black,
              fontSize: 20.0
          );
        }
      });




      /*Fluttertoast.showToast(
          msg: "$username+$password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );*/
    }
  }

  Future _postH(var data) async{
    try{
      Response response;
      response=await Dio().post(
          Api.LOGIN,
          data: data
      );
      //print(response.data);
      //print(response);
      if (response.statusCode != HttpStatus.ok){

        throw new Exception();
      }
      return response;
    }catch(e){
      Fluttertoast.showToast(
          msg: "登录失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );
      return print(e);
    }
  }


  _register(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context)=>RegisterPage()
    )
    );
  }
}




class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _pwdEditController;
  TextEditingController _userNameEditController;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _pwdEditController = TextEditingController();
    _userNameEditController = TextEditingController();
    _pwdEditController.addListener(() => setState(() => {}));
    _userNameEditController.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTopBannerWidget(),
            Divider(height: 10.0),
            _buildEditWidget(),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }


  _buildTopBannerWidget() {
    return Container(
      child: Image.asset(
        "images/login.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  _buildEditWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            width: 1.0 / MediaQuery.of(context).devicePixelRatio,
            color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        children: <Widget>[
          _buildLoginNameTextField(),
          Divider(height: 1.0),
          _buildPwdTextField(),
        ],
      ),
    );
  }

  _buildLoginNameTextField() {
    return TextField(
      controller: _userNameEditController,
      focusNode: _userNameFocusNode,
      decoration: InputDecoration(
        hintText: "用户名",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.accessibility_new),
      ),
    );
  }

  _buildPwdTextField() {
    return TextField(
      controller: _pwdEditController,
      focusNode: _pwdFocusNode,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "密码",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.border_color),
      ),
    );
  }

  _buildRegisterButton() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(width: 1.0, color: Colors.green),
                ),
                child: FlatButton(
                    onPressed: () {
                      _register();
                    },
                    child: Text(
                      "注册",
                      style: TextStyle(color: Colors.green, fontSize: 20.0),
                    )),
              ))
        ],
      ),
    );
  }


  _register()
  {
    var username = _userNameEditController.text;
    var password = _pwdEditController.text;

    if (username.length == 0) {
      /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('请输入用户名'),
          ));*/
      Fluttertoast.showToast(
          msg: "请输入用户名",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );
    } else if (password.length == 0) {
      Fluttertoast.showToast(
          msg: "请输入密码",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );
    } else {

      //TODO 网络请求

      var data={
        "username":username,
        "password":password
      };

      _postHttp(data).then((value){

        var code= jsonDecode(value.toString());
        var result = code['statuscode'];
        print(result);
        if(result=="201 CREATED")
        {
          Fluttertoast.showToast(
              msg: "注册成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,//展示时长，仅IOS有效
              backgroundColor: Colors.black26,
              textColor: Colors.black,
              fontSize: 20.0
          );

          Navigator.pop(context);
        }
      }
      );



    }
  }

  Future _postHttp(var data) async{
    try{
      Response response;
      response=await Dio().post(
          "http://192.168.1.22:8080/register",
        data: data
      );
      //print(response.data);
      //print(response);
      if (response.statusCode != HttpStatus.ok){

        throw new Exception();
      }
      return response;
    }catch(e){
      Fluttertoast.showToast(
          msg: "注册失败，请更换用户名",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,//展示时长，仅IOS有效
          backgroundColor: Colors.black26,
          textColor: Colors.black,
          fontSize: 20.0
      );
      return print(e);
    }
  }
}


