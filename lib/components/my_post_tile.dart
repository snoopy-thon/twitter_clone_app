import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/post.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  const MyPostTile({
    super.key,
    required this.post,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Text(
                widget.post.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '@${widget.post.username}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.post.message,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
          )
        ],
      ),
    );
  }
}
