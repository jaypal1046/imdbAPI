import 'package:imdb_api/ApiHelper/ApiBasehelper.dart';
import 'package:imdb_api/imdb.dart';


class ImbdRepository {


  ApiBaseHelper _helper = ApiBaseHelper();

  Future<imbdTop250> fetchMovieList() async {

   final response = await _helper.get();
   print("${response} jay1046");
    return imbdTop250.fromJson(response);
  }
}