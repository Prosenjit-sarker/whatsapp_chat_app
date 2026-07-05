import 'message.dart';

class Chat {
  final String id;
  final String name;
  final String avatarColorSeed;
  final bool isOnline;
  final bool isGroup;
  final List<Message> messages;
  int unreadCount;
  bool isPinned;
  bool isMuted;

  Chat({
    required this.id,
    required this.name,
    required this.avatarColorSeed,
    required this.messages,
    this.isOnline = false,
    this.isGroup = false,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
  });

  Message? get lastMessage => messages.isEmpty ? null : messages.last;
}
