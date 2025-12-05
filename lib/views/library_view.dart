import 'package:flutter/material.dart';
import 'package:aku_bisa_ukl/controllers/library_controller.dart';
import 'package:aku_bisa_ukl/models/library_model.dart';
import 'package:aku_bisa_ukl/navbar.dart'; 

const Color _kopiTua = Color(0xFF4A342C);
const Color _kremEmas = Color(0xFFE8DDCB);
const Color _emasLembut = Color(0xFFB8860B);

class ModalWidget {
  void showFullModal(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: _kremEmas, 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            border: Border(top: BorderSide(color: _emasLembut, width: 4)) 
          ),
          child: child,
        ),
      ),
    );
  }
}

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  
  LibraryController library = LibraryController();
  TextEditingController searchC = TextEditingController();
  List<LibraryModel>? librarys;
  List<LibraryModel>? filteredLibrarys;
  final List<String> categories = ["All", "Available", "On Loan"];
  String selectedCategory = "All";
  
  void getLibrary() {
    setState(() {
      librarys = List<LibraryModel>.from(library.librarys); 
      _filterList(); 
    });
  }

  @override
  void initState() {
    super.initState();
    getLibrary();
    searchC.addListener(_filterList);
  }

  @override
  void dispose() {
    searchC.removeListener(_filterList);
    searchC.dispose();
    super.dispose();
  }

  void _filterList() {
    final q = searchC.text.trim().toLowerCase();
    setState(() {
      filteredLibrarys = (librarys ?? []).where((d) {
        final inQuery = d.title.toLowerCase().contains(q) || d.overview.toLowerCase().contains(q);
        
        final inCategory = selectedCategory == "All" ||
            d.publisher.toLowerCase().contains(selectedCategory.toLowerCase()) ||
            d.status.toLowerCase().contains(selectedCategory.toLowerCase());
            
        return inQuery && inCategory;
      }).toList();
    });
  }

  // rate
  Widget _buildStarRating(double rating, {double size = 16}) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) {
          return Icon(Icons.star, size: size, color: _emasLembut);
        } else if (i == full && half) {
          return Icon(Icons.star_half, size: size, color: _emasLembut);
        } else {
          return Icon(Icons.star_border, size: size, color: _emasLembut.withOpacity(0.9));
        }
      }),
    );
  }

  Widget _buildCarousel() {
    final carouselItems = (librarys ?? []).take(3).toList(); 
    if (carouselItems.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180, 
      child: PageView.builder(
        itemCount: carouselItems.length,
        itemBuilder: (context, index) {
          final item = carouselItems[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _kopiTua, 
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), 
                    bottomLeft: Radius.circular(10)
                  ),
                  child: Image.network(
                    item.posterPath,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120, height: 180, color: const Color.fromARGB(255, 232, 221, 203), 
                      child: const Icon(Icons.book_online, color: Color.fromRGBO(74, 52, 44, 1), size: 40)
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _kremEmas, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Publisher: ${item.publisher}",
                          style: TextStyle(
                            color: _kremEmas.withOpacity(0.8), 
                            fontSize: 12
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStarRating(item.voteAverage, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList(String title, List<LibraryModel> listData, {bool showPublisher = true}) {
    if (listData.isEmpty) return const SizedBox.shrink();

    final double listHeight = showPublisher ? 240.0 : 200.0; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: _kopiTua, 
              fontWeight: FontWeight.w900, 
              fontSize: 16
            ),
          ),
        ),
        SizedBox(
          height: listHeight, 
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: listData.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            padding: const EdgeInsets.only(right: 4), 
            itemBuilder: (context, index) {
              final item = listData[index];
              return SizedBox(
                width: 130, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), 
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _emasLembut, width: 1), 
                        ),
                        child: Image.network(
                          item.posterPath,
                          width: 130, 
                          height: 160, 
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 130, height: 160, color: _kopiTua, 
                            child: const Icon(Icons.book_outlined, color: _kremEmas)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: _kopiTua, fontSize: 13),
                    ),
                    if (!showPublisher) 
                      Text(
                        item.overview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _kopiTua.withOpacity(0.7), fontSize: 10),
                      ),
                    if (showPublisher) ...[ 
                      Text(
                        item.publisher,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _emasLembut, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      Text(
                        item.status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _emasLembut.withOpacity(0.8), fontSize: 9),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _libraryCard(LibraryModel d) {
    return StatefulBuilder(
      builder: (context, setStateSB) {
        bool hovering = false;
        return MouseRegion(
          onEnter: (_) => setStateSB(() => hovering = true),
          onExit: (_) => setStateSB(() => hovering = false),
          child: AnimatedScale(
            scale: hovering ? 1.02 : 1,
            duration: const Duration(milliseconds: 160),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: _kopiTua.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08), 
                      blurRadius: hovering ? 12 : 6, 
                      offset: const Offset(0, 4))
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    d.posterPath,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 58,
                      height: 58,
                      color: _kremEmas,
                      child: const Icon(Icons.book, color: _kopiTua),
                    ),
                  ),
                ),
                title: Text(
                  d.title, 
                  style: const TextStyle(fontWeight: FontWeight.w700, color: _kopiTua, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.overview, 
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _kopiTua.withOpacity(0.7), fontSize: 12),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStarRating(d.voteAverage, size: 14), 
                        Text(d.status, style: const TextStyle(color: _emasLembut, fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: _emasLembut),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: _kremEmas,
                      title: Text(d.title, style: const TextStyle(color: _kopiTua)), 
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(d.posterPath, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                            const SizedBox(height: 8),
                            Text(d.overview, style: const TextStyle(color: _kopiTua)), 
                            const SizedBox(height: 8),
                            Row(children: [_buildStarRating(d.voteAverage)]) 
                          ],
                        ),
                      ),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE", style: TextStyle(color: _emasLembut)))],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  //method utama
  @override
  Widget build(BuildContext context) {
    final List<LibraryModel> allBooks = librarys ?? [];
    
    final recentlyAccessed = allBooks.take(5).toList(); 
    final popularBooks = List<LibraryModel>.from(allBooks)
      ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    final recommendedBooks = allBooks.where((e) => e.id % 2 != 0).toList(); 

    return Scaffold(
      backgroundColor: _kremEmas, 

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        backgroundColor: _kopiTua, 
        title: const Column(
          children: [
            Text(
              "Library Digital",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: _kremEmas, 
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Start your reading journey today and find inspiration",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(232, 221, 203, 0.7), 
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 120), 
        children: [
          //greeting card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _emasLembut, width: 2), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _kopiTua,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu_book, color: _kremEmas, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome, Naurah!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.from(alpha: 1, red: 0.29, green: 0.204, blue: 0.173),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Expand your horizons with diverse literature.",
                        style: TextStyle(fontSize: 13, color: _kopiTua.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //search bar
          TextField(
            controller: searchC,
            decoration: InputDecoration(
              hintText: "Search by Title or Overview...",
              prefixIcon: const Icon(Icons.search, color: _kopiTua),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _kopiTua.withOpacity(0.5))),
            ),
          ),

          const SizedBox(height: 14),

          //category chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final c = categories[i];
                final selected = c == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = c;
                      _filterList();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? _kopiTua : _kremEmas,
                      border: Border.all(color: _emasLembut, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        c,
                        style: TextStyle(
                          color: selected ? _kremEmas : _kopiTua,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),
          
          //carousel slider 
          _buildCarousel(),
          
          //terakhir diakses
          _buildHorizontalList("Terakhir Diakses", recentlyAccessed.take(5).toList(), showPublisher: false),

          //rekomendasi buku
          _buildHorizontalList("Rekomendasi", recommendedBooks.take(5).toList(), showPublisher: false),

          //populer books 
          _buildHorizontalList("Populer", popularBooks.take(5).toList()), 
          
          const SizedBox(height: 18),

          //hasil pencarian / filter
          if (filteredLibrarys == null || filteredLibrarys!.isEmpty || searchC.text.isNotEmpty || selectedCategory != "All") ...[
            const SizedBox(height: 30),
            Text(
              "Hasil Pencarian / Filter: (${filteredLibrarys?.length ?? 0} item)",
              style: const TextStyle(color: _kopiTua, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (filteredLibrarys!.isEmpty)
              const Center(child: Text("No Archives Found.", style: TextStyle(color: _kopiTua)))
            else
              ...filteredLibrarys!.map((d) => _libraryCard(d)).toList(), // Langsung mapping item ke widget
          ]
        ],
      ),

      bottomNavigationBar: const MyNavBar(0), 
    );
  }
}