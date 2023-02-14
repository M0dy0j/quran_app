import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/Screen/data_search.dart';


class Home_Screen extends StatefulWidget {
  final int controller ;
  const Home_Screen({super.key,  required this.controller});


  @override
  _Home_ScreenState createState() {
    return _Home_ScreenState();
  }
}

class _Home_ScreenState extends State<Home_Screen> {


  List _items = [];

  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["sura"];
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeab676),
      appBar: AppBar(
        backgroundColor: const Color(0xffeab676),
        leading: Container(
          child: Image.asset(
            'images/quran.png',
          ),
          margin: const EdgeInsets.only(left: 10),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: dataSearch());
              },
              icon: Icon(
                Icons.search,
                color: Colors.brown[700],
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        reverse: true,
        controller: PageController(initialPage: widget.controller),
        itemCount: 604,
        itemBuilder: (BuildContext context, int index) {
          if (_items.isNotEmpty) {
            String byPage = '';
            String surahName = '';
            int jozzNum = 0;
            bool isBasmalahShown = false;

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                byPage = byPage + ' ${ayahData['aya_text']}';
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                surahName = ayahData['sura_name_ar'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                jozzNum = ayahData['jozz'];
              }
            }

            for (Map ayahData in _items) {
              if (ayahData['page'] == index + 1) {
                if (ayahData['aya_no'] == 1 &&
                    ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                    ayahData['sura_name_ar'] != 'التوبَة') {
                  isBasmalahShown = true;
                  break;
                }
              }
            }

            return SafeArea(
              child: Container(
                decoration: index % 2 == 0
                    ? const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight))
                    : const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الجزء $jozzNum',
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                surahName,
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isBasmalahShown
                                  ? const Text(
                                "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              )
                                  : Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                byPage,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                fontFamily: 'Kitab', fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}