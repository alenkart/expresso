import 'dart:io';
import './expresso.dart';

class HttpContext {
  HttpContextRequest request;
  HttpContextResponse response;

  HttpContext(HttpRequest request) {
    this.request = HttpContextRequest(request);
    this.response = HttpContextResponse(request);
  }
}
