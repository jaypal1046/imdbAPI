import 'package:flutter/material.dart';
import 'package:imdb_api/ApiHelper/ApiResponce.dart';
import 'package:imdb_api/Bloc/block.dart';

import '../imdb.dart';

class ImageList extends StatefulWidget {
  String quary;
  ImageList({this.quary});
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {




  String query ;
  imbdBloc _bloc;


  final _unfocusedColor = Colors.grey[600];


  @override
  void initState() {
    super.initState();
    _bloc = imbdBloc();
    setState(() {
      if(widget.quary==null|| widget.quary==""){
        query="";
      }else{
        query=widget.quary;
      }

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchImageList(),
        child: StreamBuilder<ApiResponse<imbdTop250>>(
          stream: _bloc.imdbListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return

                      query==""?MovieList(movieList: snapshot.data.data):MovieListbyserach(movieList: snapshot.data.data,quary: query);

                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchImageList(),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
class MovieListbyserach extends StatelessWidget {
  final imbdTop250 movieList;
  String quary;

   MovieListbyserach({Key key, this.movieList,this.quary}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double c_width=MediaQuery.of(context).size.width*0.4;
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
        itemCount: movieList.items.length,

        itemBuilder: (context, index) {
          print(movieList.items[index]);
          var title=movieList.items[index].title;
          return title.contains(quary)?Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>OurImageView(photo:movieList.photos[index])));
                  },
                  child:  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      children: [
                        Image.network(
                          '${movieList.items[index].image}',
                          width: 120,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          children: [

                            Padding(padding: EdgeInsets.only(left: 20),child:  Container(
                              width: c_width,
                              child: Text(movieList.items[index].title,style: TextStyle(fontSize: 15,),),
                            ),),
                            Text(movieList.items[index].year,style: TextStyle(fontSize: 15,),),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: Container(
                                height: 15,
                                width: 30,
                                color: Colors.green,
                                child:  Text("${movieList.items[index].imDbRating} IMDB",style: TextStyle(fontSize: 13,),),

                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,)
              ],
            ),
          ):
          Container(height: 0.1,);

        },
      ),);
  }
}
class MovieList extends StatefulWidget {
  final imbdTop250 movieList;
  MovieList({Key key, this.movieList}) : super(key: key);
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {





  TextEditingController serachController = TextEditingController();


  String query = "";

  @override
  Widget build(BuildContext context) {
    double c_width=MediaQuery.of(context).size.width*0.4;
    return Column(
      children: [
        TextFormField(
          controller: serachController,
          onChanged: (val) {
            setState(() {
              query = val;
            });
          },
          cursorColor: Colors.black,
          autofocus: true,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 25,
          ),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black87,
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                          (_) => serachController.clear());
                  serachController.clear();
                  query = "";
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black87,
              )),
        ),
        NotificationListener<ScrollNotification>(
          child: ListView.builder(
            itemCount: widget.movieList.items.length,

            itemBuilder: (context, index) {
              print( widget.movieList.items[index]);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>OurImageView(photo:movieList.photos[index])));
                      },
                      child:  Padding(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Row(
                          children: [
                            Image.network(
                              '${ widget.movieList.items[index].image}',
                              width: 120,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                            Column(
                              children: [

                                Padding(padding: EdgeInsets.only(left: 20),child:  Container(
                                  width: c_width,
                                  child: Text( widget.movieList.items[index].title,style: TextStyle(fontSize: 15,),),
                                ),),
                                Text( widget.movieList.items[index].year,style: TextStyle(fontSize: 15,),),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),

                                  child: Container(
                                    height: 15,
                                    width: 30,
                                    color: Colors.green,
                                    child:  Text("${ widget.movieList.items[index].imDbRating} IMDB",style: TextStyle(fontSize: 13,),),

                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,)
                  ],
                ),
              );

            },
          ),)
      ],
    );
  }
}



class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.lightGreen,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}