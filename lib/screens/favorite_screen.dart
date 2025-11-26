import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/models/amiibo_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final box = Hive.box<AmiiboModel>('favoriteBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  child: TextFormField(
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
              ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<AmiiboModel> box, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final amiibo = box.getAt(index);
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          box.deleteAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${amiibo!.name} has been successfully removed from the list",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                82,
                                255,
                                88,
                              ),
                            ),
                          );
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListTile(
                            title: Text(amiibo?.name ?? ''),
                            subtitle: Text(amiibo?.gameSeries ?? ''),
                            leading: Image.network(
                              amiibo?.image ?? '',
                              width: 40,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
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
      ),
    );
  }
}
