//  lib/notification_screen.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Notification;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NotificationPage extends StatefulWidget {
  final http.Client? client;
  const NotificationPage({super.key, this.client});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final Future<List<Notification>> _future = _fetch();

  Future<List<Notification>> _fetch() async {
    const url =
        'https://raw.githubusercontent.com/shabeersha/test-api/main/test-notifications.json'; // 1. removed space
    final res = widget.client == null
        ? await http.get(Uri.parse(url))
        : await widget.client!.get(Uri.parse(url));

    if (res.statusCode == 200) return compute(_parseJsonIsolate, res.body);
    throw Exception('network ${res.statusCode}');
  }

  static List<Notification> _parseJsonIsolate(String body) {
    final decoded = jsonDecode(body);
    List<dynamic> list;
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      list = decoded['data'];
    } else if (decoded is List) {
      list = decoded;
    } else {
      throw FormatException('JSON must be {"data":[...]} or List');
    }
    return list.map((e) => Notification.fromJson(e)).toList();
  }

  static Future<Uint8List?> _downloadImageIsolate(String url) async {
    if (url.isEmpty) return null;
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) return null;
      final bytes = await consolidateHttpClientResponseBytes(response);
      httpClient.close();
      return bytes;
    } catch (_) {
      return null;
    }
  }

  String _timeAgo(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    final diff = DateTime.now().toUtc().difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} mon ago';
    if (diff.inDays > 0) return '${diff.inDays} d ago';
    if (diff.inHours > 0) return '${diff.inHours} h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} min ago';
    return 'Just now';
  }

 String _imageUrl(String? file) {
  if (file == null || file.isEmpty) return '';
  final url = 'https://raw.githubusercontent.com/shabeersha/test-api/main/$file';
  print('IMAGE URL → $url');      // <-- paste this line
  return url;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), elevation: 0),
      body: FutureBuilder<List<Notification>>(
        future: _future,
        builder: (_, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error:\n${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text('No notifications'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: list.length,
            separatorBuilder: (_, __) =>
                const Divider(indent: 15, endIndent: 15),
            itemBuilder: (_, i) {
              final item = list[i];
              final imgUrl = _imageUrl(item.image);

              return ListTile(
                leading: item.image == null
                    ? const SizedBox(width: 48)
                    : FutureBuilder<Uint8List?>(
                        future: compute(_downloadImageIsolate, imgUrl),
                        builder: (_, imgSnap) {
                          if (imgSnap.hasData && imgSnap.data != null) {
                            return Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.memory(
                                imgSnap.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                title: Text(item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.body),
                    Text(_timeAgo(item.timestamp),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Notification {
  final String id;
  final String title;
  final String body;
  final String? image;
  final String? timestamp;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    this.image,
    this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: '',
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        image: json['image']?.toString(),
        timestamp: json['timestamp']?.toString(),
      );
}