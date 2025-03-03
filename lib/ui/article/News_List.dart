import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/api/model/sources_response/Source.dart';
import 'package:news/ui/article/News_List_Viewmodel.dart';
import 'package:news/ui/content/Content_Screen.dart';
import 'package:news/ui/widget/News_Widget.dart';

class NewsList extends StatefulWidget {
  Source? source;
  String? query;
  int? page;

  NewsList({this.source, this.query, required this.page});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels != 0) {
            if (widget.page != null) {
              widget.page = (widget.page ?? 0) + 1;
              setState(() {});
            }
          }
        }
      },
    );
  }

  var viewModel = NewsListViewmodel();

  @override
  Widget build(BuildContext context) {
    viewModel.loadNews(
      q: widget.query,
      page: widget.page,
      sourceId: widget.source?.id,
    );

    return Container(
      child: BlocBuilder<NewsListViewmodel, NewsListState>(
        bloc: viewModel,
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xff39A552)),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage ?? ""),
                  ElevatedButton(onPressed: () {}, child: Text('Try again'))
                ],
              ),
            );
          } else if (state is SuccessState) {
            return ListView.separated(
              controller: scrollController,
              separatorBuilder: (context, index) => SizedBox(
                height: 30,
              ),
              itemCount: state.newsList.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ContentScreen(
                                news: state.newsList[index],
                              )));
                    },
                    child: NewsWidget(
                      news: state.newsList[index],
                    ));
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

// FutureBuilder<NewsResponse>(
// future: ApiManegar.getNews(
// source: widget.source?.id ?? "",
// q: widget.query,
// page: widget.page),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(color: Color(0xff39A552)),
// );
// }
// if (snapshot.hasError) {
// return Center(
// child: Column(
// children: [
// Text(snapshot.error.toString()),
// ElevatedButton(onPressed: () {}, child: Text('Try again'))
// ],
// ),
// );
// }
// var response = snapshot.data;
// if (response?.status == 'error') {
// return Center(
// child: Column(
// children: [
// Text(response?.message ?? ""),
// ElevatedButton(onPressed: () {}, child: Text('Try again'))
// ],
// ),
// );
// }
// var newsList = snapshot.data?.newsList;
// return ListView.separated(
// controller: scrollController,
// separatorBuilder: (context, index) => SizedBox(
// height: 30,
// ),
// itemCount: newsList?.length ?? 0,
// itemBuilder: (context, index) {
// return GestureDetector(
// onTap: () {
// Navigator.of(context).push(MaterialPageRoute(
// builder: (_) => ContentScreen(
// news: newsList[index],
// )));
// },
// child: NewsWidget(
// news: newsList![index],
// ));
// },
// );
// },
// ),