import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, abcnews, aryNews, aljazeera, argaam, cnn }

class _HomeScreenState extends State<HomeScreen> {
  // NewsViewModel newsHeadlinesModel = NewsViewModel();
  FilterList? selectedMenu;

  final formate = DateFormat('dd MMMM,yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              'images/category_icon.png',
              height: 25,
              width: 25,
            )),
        title: Text(
          "News",
          style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              color: Colors.white,
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (FilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                if (FilterList.aljazeera.name == item.name) {
                  name = 'al-jazeera-english';
                }
                if (FilterList.abcnews.name == item.name) {
                  name = 'abc-news';
                }
                if (FilterList.argaam.name == item.name) {
                  name = 'argaam';
                }
                if (FilterList.cnn.name == item.name) {
                  name = 'cnn';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              initialValue: selectedMenu,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                        value: FilterList.bbcNews, child: Text("BBC News")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.aryNews, child: Text("ARY News")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.aljazeera,
                        child: Text("Al-jazeera News")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.argaam, child: Text("Argaam ")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.cnn, child: Text("CNN ")),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.abcnews, child: Text("ABC news ")),
                  ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .45,
            width: width,

            ///futurebuilder used for asynchronos data loading,takes future object as input
            child: FutureBuilder<NewsHeadlinesModel>(
                future: NewsViewModel.fetchNewsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitThreeInOut(
                        color: Colors.orange,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles?.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        ///kyo k date and string form main a rha ha
                        return SizedBox(
                          child: Stack(
                            children: [
                              Container(
                                height: height * 0.4,
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: spinkit1,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                // left: 14,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!
                                                      .articles![index].author
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  formate.format(dateTime),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black54),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}

const spinkit1 = SpinKitThreeInOut(
  color: Colors.orange,
);
