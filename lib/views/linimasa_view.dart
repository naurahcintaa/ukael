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

class LinimasaView extends StatefulWidget {
  const LinimasaView({super.key});

  @override
  State<LinimasaView> createState() => _LinimasaViewState();
}

class _LinimasaViewState extends State<LinimasaView> {
  LibraryController library = LibraryController(); 
  final formKey = GlobalKey<FormState>();
  
  // Controllers form
  TextEditingController title = TextEditingController();
  TextEditingController overview = TextEditingController();
  TextEditingController publisher = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController posterPath = TextEditingController();
  TextEditingController searchC = TextEditingController();
  
  double voteAverageValue = 4.0; 
  int? libraryIdToUpdate; 

  List<LibraryModel>? librarys;
  List<LibraryModel>? filteredLibrarys;

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
    title.dispose();
    overview.dispose();
    publisher.dispose();
    status.dispose();
    posterPath.dispose();
    searchC.dispose();
    super.dispose();
  }

  void _filterList() {
    final q = searchC.text.trim().toLowerCase();
    setState(() {
      filteredLibrarys = (librarys ?? []).where((d) {
        // Filter title atau overview
        return d.title.toLowerCase().contains(q) || d.overview.toLowerCase().contains(q);
      }).toList();
      // Sortir ID terbaru agar yang baru ditambahkan muncul di atas
      filteredLibrarys!.sort((a, b) => b.id.compareTo(a.id));
    });
  }

  // Cari index item di list 
  int? _findIndexInOriginalById(int id) {
    if (librarys == null) return null;
    return librarys!.indexWhere((e) => e.id == id);
  }

  // Rating
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

  void _showDeleteConfirmationDialog(BuildContext context, LibraryModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _kremEmas,
        surfaceTintColor: _kremEmas,
        title: const Text("Konfirmasi Hapus", style: TextStyle(color: _kopiTua)),
        content: Text(
          "Anda yakin ingin menghapus arsip '${item.title}' dari Linimasa?",
          style: const TextStyle(color: _kopiTua),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("BATAL", style: TextStyle(color: _kopiTua, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () {
              setState(() {
                librarys!.removeWhere((d) => d.id == item.id); 
                _filterList();
              });
              Navigator.pop(context); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Arsip "${item.title}" berhasil dihapus.'))
              );
            }, 
            child: const Text("HAPUS", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // Modal CRUD
  Widget _buildCrudModal(int? originalIndex) {
    return StatefulBuilder(builder: (context, setStateSB) {
      return Container(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      libraryIdToUpdate != null ? "Edit Manuscript" : "Add New Manuscript", 
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: _kopiTua)
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: _kopiTua)),
                  ],
                ),
                const SizedBox(height: 8),
                _formField(title, "Title"), 
                _formField(overview, "Overview", maxLines: 3), 
                _formField(publisher, "Publisher"), 
                _formField(status, "Status"), 
                _formField(posterPath, "Image URL"),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vote Average", style: TextStyle(fontWeight: FontWeight.w700, color: _kopiTua)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: voteAverageValue, 
                            min: 0, max: 5, divisions: 10,
                            label: voteAverageValue.toStringAsFixed(1),
                            activeColor: _emasLembut,
                            inactiveColor: _emasLembut.withOpacity(0.3),
                            onChanged: (v) => setStateSB(() => voteAverageValue = v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStarRating(voteAverageValue, size: 20), 
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        if (libraryIdToUpdate != null && originalIndex != null) {
                          librarys![originalIndex].title = title.text;
                          librarys![originalIndex].overview = overview.text;
                          librarys![originalIndex].publisher = publisher.text;
                          librarys![originalIndex].status = status.text;
                          librarys![originalIndex].posterPath = posterPath.text;
                          librarys![originalIndex].voteAverage = double.parse(voteAverageValue.toStringAsFixed(1));
                        } else {
                          final newId = (librarys?.isNotEmpty ?? false) ? (librarys!.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1) : 1;
                          librarys!.add(LibraryModel(
                            id: newId,
                            title: title.text, 
                            overview: overview.text, 
                            publisher: publisher.text, 
                            status: status.text, 
                            posterPath: posterPath.text,
                            voteAverage: double.parse(voteAverageValue.toStringAsFixed(1)), 
                          ));
                        }
                        
                        _filterList();
                      });

                      _clearControllers();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _emasLembut,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: Text(
                    libraryIdToUpdate != null ? "SAVE CHANGES 💾" : "SAVE ARCHIVE ✒️",
                    style: const TextStyle(color: _kopiTua, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _formField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _kopiTua, fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _emasLembut, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _kopiTua.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? "$label is required" : null,
      ),
    );
  }

  void _clearControllers() {
    libraryIdToUpdate = null;
    title.clear();
    overview.clear();
    publisher.clear();
    status.clear();
    posterPath.clear();
    voteAverageValue = 4.0;
  }

  Widget _buildLibraryCard(LibraryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kopiTua.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar buku
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              item.posterPath,
              width: 70, height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70, height: 90, color: _kopiTua.withOpacity(0.1),
                child: const Icon(Icons.menu_book, color: _kopiTua),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, color: _kopiTua, fontSize: 16)),
                const SizedBox(height: 2),
                Text(item.publisher, style: TextStyle(color: _kopiTua.withOpacity(0.7), fontSize: 12)),
                const SizedBox(height: 6),
                _buildStarRating(item.voteAverage, size: 18),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            libraryIdToUpdate = item.id;
                            title.text = item.title; 
                            overview.text = item.overview; 
                            publisher.text = item.publisher; 
                            status.text = item.status; 
                            posterPath.text = item.posterPath;
                            voteAverageValue = item.voteAverage; 
                          });
                          ModalWidget().showFullModal(context, _buildCrudModal(_findIndexInOriginalById(item.id)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _emasLembut,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text("Edit", style: TextStyle(color: Color.fromRGBO(74, 52, 44, 1), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Panggil modal konfirmasi sebelum menghapus
                          _showDeleteConfirmationDialog(context, item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(74, 52, 44, 1),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kremEmas, 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        backgroundColor: _kopiTua, 
        title: const Text(
          "Linimasa Archives", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: _kremEmas, letterSpacing: 1.2)
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: _emasLembut, size: 28),
            onPressed: () {
              _clearControllers();
              ModalWidget().showFullModal(context, _buildCrudModal(null));
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 8.0),
            child: TextField(
              controller: searchC,
              decoration: InputDecoration(
                hintText: "Search by Title or Overview...",
                prefixIcon: const Icon(Icons.search, color: _kopiTua),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _kopiTua.withOpacity(0.5))
                ),
              ),
            ),
          ),
          Expanded(
            child: (filteredLibrarys == null || filteredLibrarys!.isEmpty) 
              ? Center(
                  child: Text(
                    searchC.text.isEmpty ? "No Archives to display." : "No results for \"${searchC.text}\"",
                    style: const TextStyle(color: _kopiTua, fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), // Padding bawah disesuaikan dengan BottomNavBar
                  itemCount: filteredLibrarys!.length,
                  itemBuilder: (context, index) {
                    final item = filteredLibrarys![index];
                    return InkWell(
                      onTap: () {
                        // LOGIKA SHOW DETAIL KONTEN (sesuai wireframe)
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: _kremEmas,
                            surfaceTintColor: _kremEmas,
                            title: Text(item.title, style: const TextStyle(color: _kopiTua)), 
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Image.network(item.posterPath, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
                                  const SizedBox(height: 12),
                                  Text("Publisher: ${item.publisher}", style: const TextStyle(fontWeight: FontWeight.w700, color: _kopiTua)),
                                  const SizedBox(height: 4),
                                  Row(children: [_buildStarRating(item.voteAverage)]),
                                  const SizedBox(height: 12),
                                  const Text("Sinopsis Buku:", style: TextStyle(fontWeight: FontWeight.w700, color: _kopiTua)),
                                  const SizedBox(height: 4),
                                  Text(item.overview, style: const TextStyle(color: _kopiTua)), 
                                  const SizedBox(height: 12),
                                  Text("Status: ${item.status}", style: const TextStyle(color: _emasLembut, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context), 
                                child: const Text("CLOSE", style: TextStyle(color: _emasLembut, fontWeight: FontWeight.bold))),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Fungsi "Berikan Ulasan" belum diimplementasikan.'))
                                  );
                                }, 
                                child: const Text("BERIKAN ULASAN", style: TextStyle(color: _emasLembut, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        );
                      },
                      child: _buildLibraryCard(item),
                    );
                  },
                ),
          ),
        ],
      ),
      bottomNavigationBar: const MyNavBar(1),
    );
  }
}