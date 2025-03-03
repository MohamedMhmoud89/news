import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/api/Api_Manegar.dart';
import 'package:news/api/model/sources_response/Source.dart';

class NewsScreenViewmodel extends Cubit<NewsScreenState> {
  NewsScreenViewmodel() : super(LoadingState());

  void loadNewsSource(String catId) async {
    try {
      var response = await ApiManegar.getNewsSources(catId);
      if (response.status == 'error') {
        emit(ErrorState(errorMessage: response.message));
        return;
      }
      if (response.status == 'ok') {
        emit(SuccessState(response.sources!));
        return;
      }
    } on TimeoutException catch (e) {
      emit(ErrorState(
          errorMessage: "couldn't server"
              "please check your internet connection"));
    } catch (e) {
      emit(ErrorState(
          errorMessage: "something went wrong"
              "please try again"));
    }
  }
}

abstract class NewsScreenState {}

class LoadingState extends NewsScreenState {
  String? loadingMessage;

  LoadingState({this.loadingMessage});
}

class ErrorState extends NewsScreenState {
  String? errorMessage;
  Exception? exception;

  ErrorState({this.exception, this.errorMessage});
}

class SuccessState extends NewsScreenState {
  List<Source> sources;

  SuccessState(this.sources);
}
