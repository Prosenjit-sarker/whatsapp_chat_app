import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  Widget _statusIcon() {
    switch (message.status) {
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 15, color: Colors.black45);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 15, color: Colors.black45);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 15, color: AppColors.tickBlue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final bubbleColor = isMe ? AppColors.bubbleMe : AppColors.bubbleOther;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        padding: const EdgeInsets.fromLTRB(10, 7, 8, 7),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
            bottomLeft: Radius.circular(isMe ? 8 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 8),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: const TextStyle(fontSize: 15.5, color: Colors.black87),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.time),
                  style: const TextStyle(fontSize: 11.5, color: Colors.black45),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _statusIcon(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
