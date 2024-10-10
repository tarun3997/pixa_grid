import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController controller = Get.put(HomeScreenController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        controller.loadMoreImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PixaGrid",style: TextStyle( fontWeight: FontWeight.w500),),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(() {
          if (controller.imageData.isEmpty && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            controller: _scrollController,
            itemCount: controller.imageData.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == controller.imageData.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final item = controller.imageData[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              pageBuilder: (context, _, __){
                                return Container(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SafeArea(
                                        child: IconButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, icon: const Icon(Icons.cancel)),
                                      ),
                                      Expanded(
                                        child: Image.network(item.imageUrl,
                                          width: MediaQuery.of(context).size.width,
                                          // height: MediaQuery.of(context).size.height,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: item.imageUrl,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Text('${item.likes} likes'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.visibility, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('${item.views} views'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );

        }),
      ),
    );
  }
}
