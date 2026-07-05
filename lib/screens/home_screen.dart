import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../theme.dart';
import '../widgets/chat_tile.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final TextEditingController _nameController = TextEditingController(text: 'Guest');
  final TextEditingController _phoneController = TextEditingController();
  late TabController _tabController;
  String _query = '';
  String _savedPhone = '';
  String _savedName = '';
  List<Map<String, String>> _accounts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    await _chatService.loadCurrentUser();
    await _loadSavedSession();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Chat> _contactChats() {
    return _accounts
        .map((account) => Chat(
              id: account['userId'] ?? account['phone'] ?? '',
              name: account['name'] ?? '',
              avatarColorSeed: account['phone'] ?? '',
              isOnline: true,
              messages: const [],
            ))
        .toList();
  }

  List<Chat> get _filteredChats {
    var list = _contactChats();
    if (_query.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    final pinned = list.where((c) => c.isPinned).toList();
    final rest = list.where((c) => !c.isPinned).toList();
    return [...pinned, ...rest];
  }

  Future<void> _loadSavedSession() async {
    final session = await AuthService.getSession();
    final accounts = await AuthService.getAccounts();
    if (!mounted) return;
    setState(() {
      _savedPhone = session['phone'] ?? '';
      _savedName = session['name'] ?? '';
      _accounts = accounts;
      if (_savedName.isNotEmpty) {
        _nameController.text = _savedName;
      }
      if (_savedPhone.isNotEmpty) {
        _phoneController.text = _savedPhone;
      }
    });
  }

  Future<void> _signInAndOpenChat([Chat? chat]) async {
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

    if (phone.isNotEmpty && name.isNotEmpty) {
      try {
        await _chatService.signIn(phone, name);
        await _loadSavedSession();
        if (!mounted) return;
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        return;
      }
    }

    if (chat != null) {
      _openChat(chat);
    }
  }

  Future<void> _openChat(Chat chat) async {
    if (_chatService.currentUserId.isEmpty) {
      await _chatService.loadCurrentUser();
    }

    setState(() => chat.unreadCount = 0);
    final targetUserId = chat.id;
    final room = _chatService.currentUserId.isNotEmpty && targetUserId.isNotEmpty
        ? ChatService.conversationRoomId(_chatService.currentUserId, targetUserId)
        : ChatService.roomId;
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(chat: chat, roomId: room)),
    );
  }

  Future<void> _switchAccount(Map<String, String> account) async {
    await _chatService.signIn(account['phone'] ?? '', account['name'] ?? 'Guest');
    await _loadSavedSession();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switched to ${account['name']}')),
    );
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
        actions: [
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: _showNameDialog),
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'new_group', child: Text('New group')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatsTab(),
          _buildPlaceholderTab('No status updates', Icons.donut_large),
          _buildPlaceholderTab('No call history', Icons.call),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightGreen,
        onPressed: _showNameDialog,
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }

  Widget _buildChatsTab() {
    final chats = _filteredChats;
    if (chats.isEmpty) {
      return const Center(child: Text('No contacts yet'));
    }
    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 76,
        color: AppColors.dividerGrey,
      ),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatTile(chat: chat, onTap: () => _openChat(chat));
      },
    );
  }

  Widget _buildPlaceholderTab(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.subtitleGrey),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.subtitleGrey)),
        ],
      ),
    );
  }

  Future<void> _showNameDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add account / sign in'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Phone number'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Your name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _signInAndOpenChat();
              },
              child: const Text('Save & Open'),
            ),
          ],
        );
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _ChatSearchDelegate(
        chats: _contactChats(),
        onSelected: _openChat,
      ),
    );
  }
}

class _ChatSearchDelegate extends SearchDelegate<void> {
  final List<Chat> chats;
  final void Function(Chat) onSelected;

  _ChatSearchDelegate({required this.chats, required this.onSelected});

  List<Chat> _results() => chats.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = _results();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        return ChatTile(
          chat: chat,
          onTap: () {
            close(context, null);
            onSelected(chat);
          },
        );
      },
    );
  }
}
