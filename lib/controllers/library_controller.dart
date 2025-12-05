import 'package:aku_bisa_ukl/models/library_model.dart';

class LibraryController {
  final List<LibraryModel> librarys = [
    LibraryModel(
      id: 1,
      title: "Cantik Itu Luka",
      overview: "Kisah Dewi Ayu dan keluarganya yang hidup dalam kutukan, tragedi, dan misteri hingga ia bangkit kembali untuk mengungkap semuanya.",
      publisher: "Kepustakaan Populer Gramedia",
      status: "Available",
      voteAverage: 4.7,
      posterPath: "https://www.gramedia.com/blog/content/images/2022/06/Cantik-Itu-Luka.jpg", 
    ),
    LibraryModel(
      id: 2,
      title: "Luka Cita",
      overview: "Perjalanan seseorang yang sama-sama terluka oleh kegagalan cita-cita, lalu belajar menerima keadaan dan berdamai dengan diri sendiri.",
      publisher: "Bhuana Sastra",
      status: "On Loan",
      voteAverage: 4.9,
      posterPath: "https://media.penerbitbip.id/images/books/2629/Lukacita_Depan_1675397215.jpg", 
    ),
    LibraryModel(
      id: 3,
      title: "Laut Bercerita",
      overview: "Tentang Biru Laut dan para aktivis yang hilang pada masa kelam sejarah. Ceritanya menyentuh dan mengangkat perjuangan keluarga mencari keadilan.",
      publisher: "Kepustakaan Populer Gramedia",
      status: "Available",
      voteAverage: 4.5,
      posterPath: "https://s3-ap-southeast-1.amazonaws.com/ebook-previews/40678/143505/1.jpg", 
    ),
    LibraryModel(
      id: 4,
      title: "Hello Cello",
      overview: "Kisah Helga, seorang penulis yang menyalurkan patah hatinya ke dalam tulisan, sambil menemukan kembali dirinya melalui cerita-cerita yang ia buat.",
      publisher: "Bukune",
      status: "Available",
      voteAverage: 4.7,
      posterPath: "https://cdn.gramedia.com/uploads/items/Hello_Cello.jpg", 
    ),
    LibraryModel(
      id: 5,
      title: "Yang Katanya Cemara",
      overview: "Cerita Vania tentang keluarga yang tampak sempurna, namun menyimpan luka perpisahan orang tua dan perjalanan dirinya untuk berdamai dengan kenyataan.",
      publisher: "Bukune",
      status: "Available",
      voteAverage: 4.6,
      posterPath: "https://perpustakaan.jakarta.go.id/catalog-dispusip/uploaded_files/sampul_koleksi/original/Monograf/287231.jpg", 
    ),
  ];
}