import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:enkridekrib_app/API/models/modes_dekrip.dart';
import 'package:http/http.dart' as http;

class ApiServiceDekrip {
  final String baseUrlInternal =
      'https://jay-fit-safely.ngrok-free.app/api/decrypt/internal-key';
  final String baseUrlEksternal =
      'https://jay-fit-safely.ngrok-free.app/api/decrypt/external-key';

  // take all data with json
  Future<DekripResult> fetchDataDenkrip(Map<String, dynamic> parameters) async {
    try {
      // Create multipart request
      http.MultipartRequest request;
      if (parameters['kondisi'] == "Iya") {
        request = http.MultipartRequest('POST', Uri.parse(baseUrlInternal));
        print('ini internal: $baseUrlInternal');
      } else {
        request = http.MultipartRequest('POST', Uri.parse(baseUrlEksternal));
        print("ini ekternal: baseUrlEksternal");
      }

      // Add file if it exists
      if (parameters['image_url'] != null && parameters['image_url'] is File) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            (parameters['image_url'] as File).path,
          ),
        );
      }
      // Create JSON data excluding the image
      final Map<String, dynamic> jsonData;
      if (parameters['kondisi'] == "Iya") {
        jsonData = {
          'alphabet': parameters['alphabet'],
        };
        print('ini tidak ada key');
      } else {
        jsonData = {
          'alphabet': parameters['alphabet'],
          'key': int.parse(parameters['key']),
        };
        print(parameters['key']);
      }

      // Add the JSON data as a field
      request.fields['data'] = json.encode(jsonData);

      // Send the request
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
          );

      // Get the response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return DekripResult.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load data. Status code: ${response.statusCode}. Response: ${response.body}',
        );
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('Request timed out. Please try again.');
      }
      throw Exception('Error: $e');
    }
  }
}
