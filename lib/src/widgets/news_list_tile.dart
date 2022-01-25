import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int? itemId;
  const NewsListTile({Key? key, this.itemId}) : super(key: key);

  @override
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data![itemId!],
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            // print(itemSnapshot.data);
            if (!itemSnapshot.hasData) {
              return const LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data!);
          },
        );
      },
    );
  }

  Widget buildTile(context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title!),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: <Widget>[
              const Icon(Icons.comment),
              Text('${item.descendants}')
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
        ),
        const Divider(
          height: 8.0,
        ),
      ],
    );
  }
}
