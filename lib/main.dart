import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc.dart';
import 'bloc/app_events.dart';
import 'bloc/app_states.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc',
      home: BlocProvider(
        create: (_) => AppBloc()..add(AppLoadDataEvent()),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              appBloc.add(AppReloadDataEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<AppBloc, AppStates>(
        builder: (context, state) {
          if (state is AppInitialState || state is AppLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AppLoadedState) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<AppBloc>().add(AppDeleteDataItemEvent(itemIndex: index));
                    },
                  ),
                );
              },
            );
          } else if (state is AppDeleteLoadingState) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return ListTile(title: Text(item));
              },
            );
          } else {
            return Center(child: Text('Неизвестное состояние'));
          }
        },
      ),
    );
  }
}