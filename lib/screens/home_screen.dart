import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/models/amiibo_model.dart';
import 'package:latihan_responsi/services/amiibo_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AmiiboService amiiboService = AmiiboService();
  final TextEditingController searchController = TextEditingController();
  late Future<List<AmiiboModel>> futureAmiibo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAmiibo = amiiboService.getAmiibo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Nitendo Amiibo',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        futureAmiibo = amiiboService.getAmiibo(name: value);
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.03),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(),
                          child: Row(
                            spacing: 10,
                            children: [Icon(Icons.tune), Text("Filter")],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    FutureBuilder<List<AmiiboModel>>(
                      future: futureAmiibo,
                      builder: (context, snapshot) {
                        // LOADING → skeleton
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            enabled: true,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    mainAxisExtent: 260,
                                  ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.05),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    spacing: 15,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 14,
                                              color: Colors.grey,
                                            ),
                                            Icon(
                                              Icons.favorite,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        // ERROR
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }

                        // SUCCESS
                        final amiibos = snapshot.data ?? [];

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 260,
                              ),
                          itemCount:
                              amiibos.length, //ngelag mas kalau semua heheh
                          itemBuilder: (context, index) {
                            final amiibo = amiibos[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: amiibo,
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  spacing: 15,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black,
                                              Colors.black,
                                            ],
                                          ),
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.network(
                                            amiibo.image,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(amiibo.name),
                                                Text(
                                                  amiibo.gameSeries,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable:
                                                Hive.box<AmiiboModel>(
                                                  'favoriteBox',
                                                ).listenable(),
                                            builder: (context, box, child) {
                                              bool isFav = box.values.any(
                                                (item) =>
                                                    item.name == amiibo.name,
                                              );
                                              return Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: isFav
                                                    ? Colors.red
                                                    : Colors.grey,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom nav
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
