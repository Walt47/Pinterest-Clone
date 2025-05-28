import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> categories = [
    "For you",
    "Following",
    "Arts",
    "Fashion",
    "Food",
    "Aesthetic",
    "Pets",
    "Tech",
    "Nature",
    "Anime"
  ];
  Map<String, List<String>> sharedImageUrls = {};

  @override
  void initState() {
    super.initState();
    for (String category in categories) {
      getSharedImagesURLS(category.toLowerCase());
    }
  }

  Future<void> getSharedImagesURLS(String folder) async {
    final List<String> allowedExtensions = [
      '.png',
      '.jpg',
      '.webp',
      '.jpg-Large',
      '.jfif'
    ];

    if (Platform.isAndroid) {
      String manifestContent =
          await rootBundle.loadString('AssetManifest.json');

      Map<String, dynamic> manifestMap = json.decode(manifestContent);

      List<String> imageUrls = manifestMap.keys
          .where((path) =>
              path.startsWith('images/$folder') &&
              allowedExtensions.any((ext) => path.toLowerCase().endsWith(ext)))
          .toList();

      setState(() {
        debugPrint(manifestMap.keys.toString());
        sharedImageUrls[folder] = imageUrls;
        debugPrint(sharedImageUrls.toString());
      });
    } else {
      final directory = Directory('images/$folder');

      if (!await directory.exists()) {
        return;
      }

      List<String> imageUrls = directory
          .listSync()
          .where((file) =>
              file is File &&
              allowedExtensions
                  .any((ext) => file.path.toLowerCase().endsWith(ext)))
          .map((file) => file.path.replaceAll('\\', '/'))
          .toList();

      setState(() {
        sharedImageUrls[folder] = imageUrls;
        debugPrint(sharedImageUrls.toString());
      });
    }
  }

  Widget displaySharedImages(String folder) {
    if (!sharedImageUrls.containsKey(folder) ||
        sharedImageUrls[folder] == null ||
        sharedImageUrls[folder]!.isEmpty) {
      return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(child: CircularProgressIndicator()));
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          sharedImageUrls[folder]!.length,
          (index) => StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Hero(
                          tag: 'imageHero-$index-$folder',
                          child: InteractiveViewer(
                            panEnabled: true,
                            minScale: 0.5,
                            maxScale: 4,
                            child: Image.asset(
                              sharedImageUrls[folder]![index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Hero(
                    tag: 'imageHero-$index-$folder',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        sharedImageUrls[folder]![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(flex: 1),
                      Text(
                        "...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: displaySharedImages(
                    categories[selectedIndex].toLowerCase()),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
