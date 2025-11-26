import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/models/amiibo_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AmiiboService {
  final String apiUrl = "https://www.amiiboapi.com/api/amiibo/";
  final String boxName = 'amiiboBox';
  final String favoriteBoxName = 'favoriteBox';

  // Fetch amiibo data from API and cache to Hive
  Future<List<AmiiboModel>> getAmiibo({String name = ""}) async {
    final url = name.isEmpty
        ? "https://www.amiiboapi.com/api/amiibo/"
        : "https://www.amiiboapi.com/api/amiibo/?name=$name";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['amiibo'] as List)
          .map((json) => AmiiboModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to fetch Amiibo");
    }
  }

  // Get cached amiibo data from Hive
  Future<List<AmiiboModel>> getCachedAmiibo() async {
    try {
      final box = await Hive.box<AmiiboModel>(boxName);
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to load cached data: $e');
    }
  }

  // Add amiibo to favorites
  Future<void> addToFavorite(AmiiboModel amiibo) async {
    try {
      final box = await Hive.box<AmiiboModel>(favoriteBoxName);

      // buat duplikat supaya tidak bentrok dengan amiiboBox
      final duplicate = AmiiboModel.fromJson(amiibo.toJson());

      await box.add(duplicate);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove amiibo from favorites
  Future<void> removeFromFavorite(int index) async {
    try {
      final box = await Hive.box<AmiiboModel>(favoriteBoxName);
      await box.deleteAt(index);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Get all favorite amiibos
  Future<List<AmiiboModel>> getFavorites() async {
    try {
      final box = await Hive.box<AmiiboModel>(favoriteBoxName);
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  // Check if amiibo is in favorites
  Future<bool> isFavorite(String name) async {
    try {
      final box = await Hive.box<AmiiboModel>(favoriteBoxName);
      return box.values.any((amiibo) => amiibo.name == name);
    } catch (e) {
      return false;
    }
  }

  // Search amiibo by name
  Future<List<AmiiboModel>> searchAmiibo(String query) async {
    try {
      final box = await Hive.box<AmiiboModel>(boxName);
      return box.values
          .where(
            (amiibo) =>
                amiibo.name.toLowerCase().contains(query.toLowerCase()) ||
                amiibo.character.toLowerCase().contains(query.toLowerCase()) ||
                amiibo.gameSeries.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  // Launch URL (for external links)
  Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      throw Exception('Failed to launch URL: $e');
    }
  }
}
