import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixa_grid/model/image_gallery_model.dart';

class HomeScreenController extends GetxController{
  var imageData = <ImageModel>[].obs;
  var isLoading = false.obs;
  var page = 1;

  final Dio _dio = Dio();
  final String apiKey = '46418489-00545bc1b0e6db878b44c3535';
  void fetchImages() async {
    const String url = 'https://pixabay.com/api/';
    await Future.delayed(const Duration(seconds: 2));
    if (isLoading.value) return;
    isLoading.value = true;
    try{
      final response = await _dio.get(url,queryParameters: {
        'key': apiKey,
        'q': 'nature',
        'image_type': 'photo',
        'pretty': true,
        'page': page,
        'per_page': 20
      });
      List<dynamic> hits = response.data['hits'];
      var fetchedData = hits.map((hit) => ImageModel.fromJson(hit)).toList();
      imageData.addAll(fetchedData);
      page++;
    }catch(e){
      print(e);
    }finally{
      isLoading.value = false;
    }

  }
  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }
  void loadMoreImages() {
    if (!isLoading.value) {
      fetchImages();
    }
  }
}