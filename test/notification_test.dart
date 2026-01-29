// test/notification_test.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:notification/notification_screen.dart' as screen;

/* -------------------------------------------------
   1.  MODEL TEST  –  JSON parsing
-------------------------------------------------- */
void main() {
  group('Notification model', () {
    test('parses a single object', () {
      final json = {'id': '1', 'heading': 'Title', 'message': 'Body'};
      final n = screen.Notification.fromJson(json);
      expect(n.id, '1');
      expect(n.title, 'Title');
      expect(n.body, 'Body');
    });

    test('fills empty strings when keys are missing', () {
      final n = screen.Notification.fromJson({});
      expect(n.id, '');
      expect(n.title, '');
      expect(n.body, '');
    });
  });

  /* -------------------------------------------------
     2.  REPOSITORY TEST  –  remote fetching
  -------------------------------------------------- */
  group('NotificationRepository', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((req) async {
        const url =
            'https://raw.githubusercontent.com/shabeersha/test-api/main/test-notifications.json'; // <- space removed
        if (req.url.toString() == url) {
          final payload = [
            {'id': '11', 'heading': 'Offer', 'message': '50% off'},
            {'id': '22', 'heading': 'Info', 'message': 'Store closed'},
          ];
          return Response(jsonEncode(payload), 200);
        }
        return Response('Not found', 404);
      });
    });

    test('returns List<Notification> on 200', () async {
      final repo = NotificationRepository(mockClient);
      final list = await repo.fetch();
      expect(list.length, 2);
      expect(list.first.title, 'Offer');
    });

    test('throws on non-200', () async {
      final badClient = MockClient((_) async => Response('oops', 500));
      final repo = NotificationRepository(badClient);
      expect(() => repo.fetch(), throwsA(isA<Exception>()));
    });
  });

  /* -------------------------------------------------
     3.  WIDGET TEST  –  NotificationPage
  -------------------------------------------------- */
  group('NotificationPage', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((req) async {
        final payload = [
          {'id': '1', 'heading': 'Heading', 'message': 'Message text'},
        ];
        return Response(jsonEncode(payload), 200);
      });
    });

    testWidgets('shows progress while loading', (tester) async {
      await tester.pumpWidget(_makeTestable(mockClient));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list when data arrives', (tester) async {
      await tester.pumpWidget(_makeTestable(mockClient));
      await tester.pumpAndSettle();
      expect(find.text('Heading'), findsOneWidget);
      expect(find.text('Message text'), findsOneWidget);
    });

    testWidgets('shows error when request fails', (tester) async {
      final badClient = MockClient((_) async => Response('error', 500));
      await tester.pumpWidget(_makeTestable(badClient));
      await tester.pumpAndSettle();
      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });
}

/* ========================================================
   Helper: simple repository (same logic as screen)
======================================================== */
class NotificationRepository {
  final Client _client;
  NotificationRepository(this._client);

  Future<List<screen.Notification>> fetch() async {
    const url =
        'https://raw.githubusercontent.com/shabeersha/test-api/main/test-notifications.json';
    final res = await _client.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('network ${res.statusCode}');
    final decoded = jsonDecode(res.body);
    if (decoded is List) {
      return decoded.map((e) => screen.Notification.fromJson(e)).toList();
    } else if (decoded is Map<String, dynamic>) {
      return [screen.Notification.fromJson(decoded)];
    }
    throw FormatException('bad json shape');
  }
}

/* -------------------------------------------------
   Helper: pump the real screen with a mock repo
-------------------------------------------------- */
Widget _makeTestable(Client client) {
  return MaterialApp(
    home: screen.NotificationPage(client: client),
  );
}