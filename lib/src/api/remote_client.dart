import 'package:http/http.dart' as http;

import 'client.dart';

class YourHealthRemoteClient implements YourHealthClient {
  final client = http.Client();

  @override
  Future get(Uri url, {Map<String, String>? headers}) => client.get(url, headers: headers);
}
