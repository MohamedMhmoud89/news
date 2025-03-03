import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/ui/article/Article_Screen.dart';
import 'package:news/ui/news/News_Screen_Viewmodel.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = 'news';
  String? titleBar;
  String? category;

  NewsScreen({this.titleBar, this.category});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isSearch = false;
  var searchController = TextEditingController();
  int? page = 1;
  var viewModel = NewsScreenViewmodel();

  @override
  Widget build(BuildContext context) {
    viewModel.loadNewsSource(widget.category!);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/images/pattern.png'),
              fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          actions: isSearch
              ? null
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        page = null;
                        isSearch = true;
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.search_rounded,
                        size: 26,
                      ),
                    ),
                  ),
                ],
          title: isSearch
              ? Container(
                  margin: EdgeInsets.only(right: 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff39A552), width: 2)),
                  child: TextField(
                    cursorColor: Color(0xff39A552),
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: 'Searching...',
                        hintStyle: TextStyle(color: Color(0x4739a552)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              color: Color(0xff39A552),
                            )),
                        prefixIcon: IconButton(
                            onPressed: () {
                              page = 1;
                              searchController.clear();
                              isSearch = false;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: Color(0xff39A552),
                            ))),
                  ))
              : Text('${widget.titleBar} News'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder<NewsScreenViewmodel, NewsScreenState>(
            bloc: viewModel,
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
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
                return ArticleScreen(
                  page: page,
                  query: searchController.text,
                  sources: state.sources,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

// FutureBuilder<SourcesResponse>(
// future: ApiManegar.getNewsSources(widget.category ?? ""),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(),
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
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 30),
// child: Column(
// spacing: 40,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// response?.message ?? "",
// style: GoogleFonts.poppins(
// textStyle: TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 14,
// color: Color(0xff42505C))),
// ),
// ElevatedButton(
// onPressed: () {},
// child: Text(
// 'Try again',
// style: GoogleFonts.poppins(
// textStyle: TextStyle(
// fontWeight: FontWeight.w500,
// fontSize: 14,
// color: Colors.white)),
// ),
// style: ElevatedButton.styleFrom(
// backgroundColor: Color(0xff39A552),
// ),
// )
// ],
// ),
// ),
// );
// }
// return ArticleScreen(
// page: page,
// query: searchController.text,
// sources: response?.sources,
// );
// },
// ),

// class NewsSearchDelegate extends SearchDelegate{
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(onPressed: (){query = "";}, icon: Icon(Icons.clear , color: Color(0xff39A552),),)
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return
//       IconButton(onPressed: (){
//         Navigator.pop(context);
//       }, icon: Icon(Icons.arrow_back , color: Color(0xff39A552),),);
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical:20 ),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//               image: AssetImage('assets/images/pattern.png'),
//               fit: BoxFit.fill)),
//       child: FutureBuilder<NewsResponse>(
//         future: ApiManegar.getNews(q: query),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: Color(0xff39A552)),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 children: [
//                   Text(snapshot.error.toString()),
//                   ElevatedButton(onPressed: () {}, child: Text('Try again'))
//                 ],
//               ),
//             );
//           }
//           var response = snapshot.data;
//           if (response?.status == 'error') {
//             return Center(
//               child: Column(
//                 children: [
//                   Text(response?.message ?? ""),
//                   ElevatedButton(onPressed: () {}, child: Text('Try again'))
//                 ],
//               ),
//             );
//           }
//           var newsList = snapshot.data?.newsList;
//           return ListView.separated(
//             separatorBuilder: (context, index) => SizedBox(
//               height: 30,
//             ),
//             itemCount: newsList?.length ?? 0,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (_) => ContentScreen(
//                           news: newsList[index],
//                         )));
//                   },
//                   child: NewsWidget(
//                     news: newsList![index],
//                   ));
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//               image: AssetImage('assets/images/pattern.png'),
//               fit: BoxFit.fill)),
//       child: Center(
//         child: Text('Suggestions'),
//       ),
//     );
//   }
//
// }
