import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'package:html/parser.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int? itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;
  const Comment(
      {Key? key, this.itemId, required this.itemMap, required this.depth})
      : super(key: key);

  @override
  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final items = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildText(items),
            subtitle: items.by == "" ? const Text('Deleted') : Text(items.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0,
            ),
          ),
          const Divider(),
        ];

        items.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        });

        return Column(children: children);
      },
    );
  }

  Widget buildText(item) {
    final text = parse(item.text).documentElement!.text;
    // .toString()
    // .replaceAll('&#x27;', "'")
    // .replaceAll('<p>', "\n\n")
    // .replaceAll('</p>', '');
    return Text(text);
  }
}
