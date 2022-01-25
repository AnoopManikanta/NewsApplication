import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final child;

  const Refresh({Key? key, this.child}) : super(key: key);

  @override
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
      child: child,
    );
  }
}
