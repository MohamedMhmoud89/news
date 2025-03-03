import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/api/Api_Manegar.dart';
import 'package:news/api/model/news_response/News.dart';

class NewsListViewmodel extends Cubit<NewsListState> {
  NewsListViewmodel() : super(LoadingState());

  void loadNews({String? sourceId, int? page, String? q}) async {
    try {
      var response =
          await ApiManegar.getNews(page: page, q: q, source: sourceId);
      if (response.status == 'error') {
        emit(ErrorState(errorMessage: response.message));
        return;
      }
      if (response.status == 'ok') {
        emit(SuccessState(response.newsList!));
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

abstract class NewsListState {}

class LoadingState extends NewsListState {
  String? loadingMessage;

  LoadingState({this.loadingMessage});
}

class ErrorState extends NewsListState {
  String? errorMessage;
  Exception? exception;

  ErrorState({this.exception, this.errorMessage});
}

class SuccessState extends NewsListState {
  List<News> newsList;

  SuccessState(this.newsList);
}
