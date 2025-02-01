import 'dart:convert';

import '../../api/api.dart';

import 'dto.dart';

abstract class DynamicRepository {
  Future<DynamicDTO> loadData();
}

class DynamicRepositoryImpl implements DynamicRepository {
  final YourHealthAppApi _api;
  final YourHealthClient _client;

  const DynamicRepositoryImpl({
    required YourHealthAppApi api,
    required YourHealthClient client,
  })  : _api = api,
        _client = client;

  @override
  Future<DynamicDTO> loadData() async {
    final data = await _client.get(Uri.parse(_api.mock));
    return DynamicDTO.fromJson(jsonDecode(data.body));
  }
}
