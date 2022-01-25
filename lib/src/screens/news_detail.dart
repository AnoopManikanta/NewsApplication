import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final itemId;

  const NewsDetail({Key? key, this.itemId}) : super(key: key);

  @override
  Widget build(context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading...");
        }
        final itemFuture = snapshot.data![itemId];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return const Text('Item Loading....');
            }
            return buildList(itemSnapshot.data, snapshot.data!);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel? item, Map<int, Future<ItemModel?>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item!));
    final commnentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();
    children.addAll(commnentsList);
    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        // alignment: Alignment.topCenter,
        child: Text(
          item.title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
