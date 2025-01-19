export 'client.dart';

class YourHealthAppApi {
  static const mockString = 'http://158.160.30.46:8080/health_mock';

  final String mock;

  const YourHealthAppApi({this.mock = mockString});
}
