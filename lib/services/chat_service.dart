import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/message.dart';
import 'auth_service.dart';

class ChatService {
  static const String roomId = 'global-room';
  static String _currentUserId = '';
  static String _currentUserName = '';

  static String conversationRoomId(String firstUserId, String secondUserId) {
    final ids = [firstUserId, secondUserId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  bool get _isFirebaseReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  String get currentUserId => _currentUserId;
  String get currentUserName => _currentUserName;

  Future<void> signIn(String phone, String displayName) async {
    if (!_isFirebaseReady) {
      throw Exception('Firebase is not initialized yet.');
    }

    final normalizedPhone = AuthService.normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw Exception('Please enter a phone number.');
    }

    final cleanName = displayName.trim().isEmpty ? 'Guest' : displayName.trim();
    final userId = AuthService.generateUserId(normalizedPhone);

    // Save user info to Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'uid': userId,
      'displayName': cleanName,
      'phone': normalizedPhone,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Save to local storage
    await AuthService.saveSession(normalizedPhone, cleanName);

    // Update current user
    _currentUserId = userId;
    _currentUserName = cleanName;
  }

  Stream<List<Message>> messagesStream({String? room}) {
    if (!_isFirebaseReady) {
      return const Stream<List<Message>>.empty();
    }

    final roomName = room ?? roomId;

    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomName)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromJson(
                  doc.data(),
                  currentUserId: _currentUserId,
                ))
            .toList());
  }

  Future<void> sendMessage(String text, {String? room}) async {
    if (!_isFirebaseReady) {
      throw Exception('Firebase is not initialized yet.');
    }

    if (_currentUserId.isEmpty) {
      throw Exception('You need to sign in before sending messages.');
    }

    final message = text.trim();
    if (message.isEmpty) {
      return;
    }

    final roomName = room ?? roomId;

    await FirebaseFirestore.instance.collection('rooms').doc(roomName).collection('messages').add({
      'senderId': _currentUserId,
      'senderName': _currentUserName,
      'text': message,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'sent',
    });
  }

  Future<void> loadCurrentUser() async {
    final session = await AuthService.getSession();
    _currentUserId = session['userId'] ?? '';
    _currentUserName = session['name'] ?? '';
  }
}
