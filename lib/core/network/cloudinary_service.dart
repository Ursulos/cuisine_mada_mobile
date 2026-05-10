import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const String cloudName = 'dirrtzrqe';
  static const String uploadPreset = 'cuisine_mada';
  static const String uploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static Future<String?> uploadImage(Uint8List imageBytes,
      String fileName) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'cuisine_mada';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'] as String;
      } else {
        print('Erreur Cloudinary: ${jsonData['error']}');
        return null;
      }
    } catch (e) {
      print('Erreur upload: $e');
      return null;
    }
  }
}