import 'package:cookie_jar/cookie_jar.dart';

import 'package:dio/dio.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'api.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';


class HttpUtil {

  static HttpUtil instance;

  Dio dio;

  BaseOptions options;



  CancelToken cancelToken = CancelToken();



  static HttpUtil getInstance() {

    if (null == instance) instance = HttpUtil();

    return instance;

  }



  /*

   * config it and create

   */

  HttpUtil() {

    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数

    options = BaseOptions(

      //请求基地址,可以包含子路径

      baseUrl: Api.BASE_URL,

      //连接服务器超时时间，单位是毫秒.

      connectTimeout: 10000,

      //响应流上前后两次接受到数据的间隔，单位为毫秒。

      receiveTimeout: 5000,

      //Http请求头.

      headers: {

        //do something

        "version": "1.0.0"

      },

      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.

      //contentType: Headers.formUrlEncodedContentType,

      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,

      //responseType: ResponseType.plain,

    );



    dio = Dio(options);



    //Cookie管理

    dio.interceptors.add(CookieManager(CookieJar()));



    //添加拦截器

    dio.interceptors

        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {

      print("请求之前");

      //在发送前到SharedPreferences（本地存储）中取出token的值，然后添加到请求头中
      // dio.lock()是先锁定请求不发送出去，当整个取值添加到请求头后再dio.unlock()解锁发送出去                dio.lock();                Future<dynamic> future = Future(()async{                    SharedPreferences prefs =await SharedPreferences.getInstance();                    return prefs.getString("loginToken");                });                return future.then((value) {                    options.headers["Authorization"] = value;                    return options;                }).whenComplete(() => dio.unlock()); // unlock the dio

      dio.lock();
      Future<dynamic> future = Future(()async{
        SharedPreferences prefs =await SharedPreferences.getInstance();
        print("Bearer "+prefs.getString("jwt"));
        return "Bearer "+prefs.getString("jwt");
      });

      return future.then((value) {
        options.headers["Authorization"] = value;
        return options;
      }).whenComplete(() => dio.unlock()); // unlock the dio


      // Do something before request is sent

      //return options; //continue

    }, onResponse: (Response response) {

      print("响应之前");

      dio.lock();

      var code= jsonDecode(response.toString());
      var jwt = code['data'];

      Future<dynamic> future = Future(()async{
        SharedPreferences prefs =await SharedPreferences.getInstance();
        prefs.setString("jwt", jwt);
      });

      return future.then((value) {
        return response;
      }).whenComplete(() => dio.unlock());



      // Do something with response data

      return response; // continue

    }, onError: (DioError e) {

      print("错误之前");

      // Do something with response error

      return e; //continue

    }));

  }



  /*

   * get请求

   */

  get(url, {data, options, cancelToken}) async {

    Response response;

    try {

      response = await dio.get(url,

          queryParameters: data, options: options, cancelToken: cancelToken);

      print('get success---------${response.statusCode}');

      print('get success---------${response.data}');



//      response.data; 响应体

//      response.headers; 响应头

//      response.request; 请求体

//      response.statusCode; 状态码



    } on DioError catch (e) {

      print('get error---------$e');

      formatError(e);

    }

    return response;

  }



  /*

   * post请求

   */

  post(url, {data, options, cancelToken}) async {

    Response response;

    try {

      response = await dio.post(url,

          data: data, options: options, cancelToken: cancelToken);

      print('post success---------${response.data}');

    } on DioError catch (e) {

      print('post error---------$e');

      formatError(e);

    }

    return response;

  }



  /*

   * 下载文件

   */

  downloadFile(urlPath, savePath) async {

    Response response;

    try {

      response = await dio.download(urlPath, savePath,

          onReceiveProgress: (int count, int total) {

            //进度

            print("$count $total");

          });

      print('downloadFile success---------${response.data}');

    } on DioError catch (e) {

      print('downloadFile error---------$e');

      formatError(e);

    }

    return response.data;

  }



  /*

   * error统一处理

   */

  void formatError(DioError e) {

    if (e.type == DioErrorType.CONNECT_TIMEOUT) {

      // It occurs when url is opened timeout.

      print("连接超时");

    } else if (e.type == DioErrorType.SEND_TIMEOUT) {

      // It occurs when url is sent timeout.

      print("请求超时");

    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {

      //It occurs when receiving timeout

      print("响应超时");

    } else if (e.type == DioErrorType.RESPONSE) {

      // When the server response, but with a incorrect status, such as 404, 503...

      print("出现异常");

    } else if (e.type == DioErrorType.CANCEL) {

      // When the request is cancelled, dio will throw a error with this type.

      print("请求取消");

    } else {

      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.

      print("未知错误");

    }

  }



  /*

   * 取消请求

   *

   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。

   * 所以参数可选

   */

  void cancelRequests(CancelToken token) {

    token.cancel("cancelled");

  }

}