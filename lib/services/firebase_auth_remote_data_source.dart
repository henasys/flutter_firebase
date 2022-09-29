import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource {
  final String url = FlutterConfig.get('CREATE_CUSTOM_TOKEN_URL');

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    print('T1' + user.toString());
    final customTokenResponse = await http.post(Uri.parse(url), body: user);
    return customTokenResponse.body;
  }
}
