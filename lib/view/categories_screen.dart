import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/constants/constant_color.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/view/home_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsHeadlinesModel = NewsViewModel();

  final formate = DateFormat('dd MMMM,');
  String catrgoryName = 'general';
  List<String> CategoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        catrgoryName = CategoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: catrgoryName == CategoriesList[index]
                                  ? Constant.kColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                                child: Text(
                              CategoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14),
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: NewsViewModel.fetchNewsCategoires(catrgoryName),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitThreeInOut(
                          color: Constant.kColor,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.articles?.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                ///ClipRRect is often used to create rounded corners for images,
                                /// but it can be applied to any widget.
                                /// Hide parts of a widget that extend beyond a specific area.
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),

                                  ///cachednetwork purpose: Images are stored locally after being downloaded once.
                                  child: CachedNetworkImage(
                                    height: height * 0.1,
                                    width: width * 0.3,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,

                                    ///placeholder purpose: provide a visual indication while an image is being loaded from the network
                                    ///preventing empty spaces or blank areas on the screen during loading.
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
                                Expanded(
                                    child: Container(
                                  height: height * 0.1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54),
                                        ),
                                        // const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Constant.kColor),
                                            ),
                                            Text(
                                              formate.format(dateTime),
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
