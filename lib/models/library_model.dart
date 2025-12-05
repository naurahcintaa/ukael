class LibraryModel {
  int id;
  String title;
  String overview;
  String publisher;
  String status;
  double voteAverage;
  String posterPath;
  String? photoUrl;

  LibraryModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.publisher,
    required this.status,
    required this.voteAverage,
    required this.posterPath,
    this.photoUrl,
  });
}
