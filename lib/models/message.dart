import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

extension MessageStatusX on MessageStatus {
  String get value => switch (this) {
        MessageStatus.sent => 'sent',
        MessageStatus.delivered => 'delivered',
        MessageStatus.read => 'read',
      };

  static MessageStatus fromValue(String? value) {
    return switch (value) {
      'sent' => MessageStatus.sent,
      'delivered' => MessageStatus.delivered,
      'read' => MessageStatus.read,
      _ => MessageStatus.read,
    };
  }
}

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

  factory Message.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final senderId = json['senderId'] as String?;
    return Message(
      id: json['id'] ?? json['senderId'] ?? DateTime.now().toIso8601String(),
      text: json['text']?.toString() ?? '',
      time: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isMe: senderId != null && currentUserId != null && senderId == currentUserId,
      status: MessageStatusX.fromValue(json['status']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'time': time.toUtc().toIso8601String(),
      'isMe': isMe,
      'status': status.value,
    };
  }
}
