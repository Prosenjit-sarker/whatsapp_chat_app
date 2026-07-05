import '../models/chat.dart';
import '../models/message.dart';

List<Chat> buildMockChats() {
  final now = DateTime.now();

  return [
    Chat(
      id: '1',
      name: 'Ayesha Rahman',
      avatarColorSeed: 'AR',
      isOnline: true,
      unreadCount: 2,
      isPinned: true,
      messages: [
        Message(
          id: 'm1',
          text: "Hey! Are we still on for lunch tomorrow?",
          time: now.subtract(const Duration(hours: 3)),
          isMe: false,
        ),
        Message(
          id: 'm2',
          text: "Yes, absolutely! 1pm works for me.",
          time: now.subtract(const Duration(hours: 2, minutes: 50)),
          isMe: true,
          status: MessageStatus.read,
        ),
        Message(
          id: 'm3',
          text: "Perfect, see you then 😊",
          time: now.subtract(const Duration(minutes: 12)),
          isMe: false,
        ),
        Message(
          id: 'm4',
          text: "Bringing the documents too",
          time: now.subtract(const Duration(minutes: 10)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '2',
      name: 'Family Group',
      avatarColorSeed: 'FG',
      isGroup: true,
      unreadCount: 5,
      messages: [
        Message(
          id: 'm1',
          text: "Don't forget dinner at 8pm tonight",
          time: now.subtract(const Duration(hours: 5)),
          isMe: false,
        ),
        Message(
          id: 'm2',
          text: "I'll bring dessert!",
          time: now.subtract(const Duration(hours: 4, minutes: 40)),
          isMe: true,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm3',
          text: "Sounds great, see everyone soon",
          time: now.subtract(const Duration(hours: 1)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '3',
      name: 'Tanvir Hasan',
      avatarColorSeed: 'TH',
      isOnline: false,
      messages: [
        Message(
          id: 'm1',
          text: "Can you send me the report?",
          time: now.subtract(const Duration(days: 1, hours: 2)),
          isMe: false,
        ),
        Message(
          id: 'm2',
          text: "Sure, sending it now.",
          time: now.subtract(const Duration(days: 1, hours: 1, minutes: 55)),
          isMe: true,
          status: MessageStatus.read,
        ),
      ],
    ),
    Chat(
      id: '4',
      name: 'Nadia Islam',
      avatarColorSeed: 'NI',
      isOnline: true,
      isMuted: true,
      messages: [
        Message(
          id: 'm1',
          text: "Happy Birthday! 🎉🎂",
          time: now.subtract(const Duration(days: 2)),
          isMe: false,
        ),
        Message(
          id: 'm2',
          text: "Thank you so much!",
          time: now.subtract(const Duration(days: 2, minutes: -5)),
          isMe: true,
          status: MessageStatus.read,
        ),
      ],
    ),
    Chat(
      id: '5',
      name: 'Project Alpha Team',
      avatarColorSeed: 'PA',
      isGroup: true,
      unreadCount: 12,
      messages: [
        Message(
          id: 'm1',
          text: "Deployment went smoothly, no issues found",
          time: now.subtract(const Duration(days: 3)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '6',
      name: 'Rafiq Uddin',
      avatarColorSeed: 'RU',
      isOnline: false,
      messages: [
        Message(
          id: 'm1',
          text: "Let's catch up soon!",
          time: now.subtract(const Duration(days: 6)),
          isMe: false,
        ),
      ],
    ),
  ];
}
