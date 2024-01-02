import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      "https://development.pearl-developer.com/webapps/welcome/app_info";

  static Future<String> fetchUrlFromApi({
    required String key,
    required String code,
    required String erpName,
    required String appName,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['key'] = key;
      request.fields['code'] = code;
      request.fields['erp_name'] = erpName;
      request.fields['app_name'] = appName;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        final responseCode = jsonResponse['response'];

        if (responseCode == "1") {
          final appUrl = jsonResponse['message'][0]['app_link'];
          return appUrl;
        } else {
          throw Exception("API returned an error: ${jsonResponse['message']}");
        }
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      print("Error fetching data from API: $e");
      throw Exception("Failed to fetch data from API: $e");
    }
  }
}
