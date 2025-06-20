// lib/bloc/app_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_events.dart';
import 'app_states.dart';

class AppBloc extends Bloc<AppEvents, AppStates> {
  AppBloc() : super(AppInitialState()) {
    // обработка события загрузки данных
    on<AppLoadDataEvent>((event, emit) async {
      emit(AppLoadingState());
      await Future.delayed(Duration(seconds: 1)); // имитация задержки
      List<String> initialData = ['Item 1', 'Item 2', 'Item 3'];
      emit(AppLoadedState(data: initialData));
    });

    // обработка события перезагрузки данных
    on<AppReloadDataEvent>((event, emit) async {
      emit(AppLoadingState());
      await Future.delayed(Duration(seconds: 1));
      List<String> reloadedData = ['Item A', 'Item B', 'Item C'];
      emit(AppLoadedState(data: reloadedData));
    });

    // Обработка удаления элемента из списка
    on<AppDeleteDataItemEvent>((event, emit) {
      if (state is AppLoadedState) {
        final currentState = state as AppLoadedState;
        final newData = List<String>.from(currentState.data);
        if (event.itemIndex >= 0 && event.itemIndex < newData.length) {
          newData.removeAt(event.itemIndex);
          emit(AppDeleteLoadingState(data: newData));
        }
      }
    });
  }
}