import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/chat.dart';
import '../theme.dart';
import '../widgets/chat_tile.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<Chat> _chats;
  late TabController _tabController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _chats = buildMockChats();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Chat> get _filteredChats {
    var list = _chats;
    if (_query.isNotEmpty) {
      list = list
          .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    final pinned = list.where((c) => c.isPinned).toList();
    final rest = list.where((c) => !c.isPinned).toList();
    return [...pinned, ...rest];
  }

  void _openChat(Chat chat) {
    setState(() => chat.unreadCount = 0);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(chat: chat)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Chat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
        actions: [
          IconButton(
              icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (_) {},
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'new_group', child: Text('New group')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
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
        onPressed: () {},
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildChatsTab() {
    final chats = _filteredChats;
    if (chats.isEmpty) {
      return const Center(child: Text('No chats found'));
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

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _ChatSearchDelegate(
        chats: _chats,
        onSelected: _openChat,
      ),
    );
  }
}

class _ChatSearchDelegate extends SearchDelegate<void> {
  final List<Chat> chats;
  final void Function(Chat) onSelected;

  _ChatSearchDelegate({required this.chats, required this.onSelected});

  List<Chat> _results() => chats
      .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

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
