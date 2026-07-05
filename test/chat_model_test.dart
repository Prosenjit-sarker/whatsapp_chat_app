import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_clone/models/message.dart';

void main() {
  test('message serializes to a Firestore-friendly map', () {
    final message = Message(
      id: 'msg-1',
      text: 'Hello from the test',
      time: DateTime.utc(2024, 1, 1, 12, 0),
      isMe: true,
      status: MessageStatus.sent,
    );

    final data = message.toJson();

    expect(data['text'], 'Hello from the test');
    expect(data['isMe'], true);
    expect(data['status'], 'sent');
  });
}
