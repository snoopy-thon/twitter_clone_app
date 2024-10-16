import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone_app/components/my_drawer.dart';
import 'package:twitter_clone_app/components/my_input_alert_box.dart';
import 'package:twitter_clone_app/components/my_post_tile.dart';
import 'package:twitter_clone_app/services/database/database_provider.dart';

import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
          textController: _messageController,
          hintText: "What's on your mind?",
          onPressed: () async {
            await postMessage(_messageController.text);
          },
          onPressedText: "Post"),
    );
  }

  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: const Icon(Icons.add),
      ),
      body: _buildPostList(listeningProvider.allPosts),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? const Center(
            child: Text("Nothing here.."),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return MyPostTile(post: post);
            });
  }
}
