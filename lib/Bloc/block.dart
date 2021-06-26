import 'dart:async';
import 'package:imdb_api/ApiHelper/ApiResponce.dart';
import 'file:///D:/syit/Supportguru/avekvurna/imdb_api/lib/imdb/imdbReposetry.dart';
import 'package:imdb_api/imdb.dart';
class imbdBloc {
  ImbdRepository imbdRepository;
  StreamController _imbdListController;
String baseurl;
  StreamSink<ApiResponse<imbdTop250>> get imdbListSink =>
      _imbdListController.sink;

  Stream<ApiResponse<imbdTop250>> get imdbListStream {
    print(_imbdListController.stream);
    return _imbdListController.stream;
  }


  imbdBloc() {

    _imbdListController = StreamController<ApiResponse<imbdTop250>>();
    imbdRepository = ImbdRepository();

    fetchImageList();
  }

  fetchImageList() async {
    imdbListSink.add(ApiResponse.loading('Fetching IMDB List'));
    try {
      imbdTop250 movies = await imbdRepository.fetchMovieList();
      imdbListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      imdbListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _imbdListController?.close();
  }
}