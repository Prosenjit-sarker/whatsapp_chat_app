import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../theme.dart';
import 'avatar.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = now.year == time.year &&
        now.month == time.month &&
        now.day == time.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == time.year &&
        yesterday.month == time.month &&
        yesterday.day == time.day;

    if (isToday) return DateFormat('HH:mm').format(time);
    if (isYesterday) return 'Yesterday';
    return DateFormat('dd/MM/yy').format(time);
  }

  Widget _statusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 16, color: AppColors.subtitleGrey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all,
            size: 16, color: AppColors.subtitleGrey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 16, color: AppColors.tickBlue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.lastMessage;
    final hasUnread = chat.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatAvatar(seed: chat.avatarColorSeed, isGroup: chat.isGroup),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          _formatTime(lastMessage.time),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: hasUnread
                                ? AppColors.lightGreen
                                : AppColors.subtitleGrey,
                            fontWeight:
                            hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (lastMessage != null && lastMessage.isMe) ...[
                        _statusIcon(lastMessage.status),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          lastMessage?.text ?? 'Say hello 👋',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: AppColors.subtitleGrey,
                            fontWeight:
                            hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.isMuted)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.volume_off,
                              size: 15, color: AppColors.subtitleGrey),
                        ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: AppColors.unreadBadge,
                            shape: BoxShape.circle,
                          ),
                          constraints:
                          const BoxConstraints(minWidth: 20, minHeight: 20),
                          child: Text(
                            '${chat.unreadCount}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
