enum MessageStatus { sent, delivered, read }

class Message {
  final String id;
  final String text;
  final DateTime time;
  final bool isMe;
  final MessageStatus status;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.status = MessageStatus.read,
  });
}
