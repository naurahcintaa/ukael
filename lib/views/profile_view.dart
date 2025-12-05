import 'package:flutter/material.dart';
import 'package:aku_bisa_ukl/navbar.dart'; 

const Color _kopiTua = Color(0xFF4A342C);
const Color _kremEmas = Color(0xFFE8DDCB);
const Color _emasLembut = Color(0xFFB8860B);

//pinjaman
class LoanHistoryItem extends StatelessWidget {
  final Map<String, dynamic> loan;
  final VoidCallback onTap;

  const LoanHistoryItem({
    super.key,
    required this.loan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReturned = loan['isReturned'];
    final Color statusColor = isReturned ? Colors.green.shade700 : Colors.red.shade600;
    final String statusText = isReturned ? 'Dikembalikan' : 'Sedang Dipinjam';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isReturned ? Colors.green.shade300 : _emasLembut,
            width: 2,
          ),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  color: _kopiTua.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _emasLembut, width: 1),
                ),
                child: Center(
                  child: Icon(
                    Icons.book_sharp,
                    color: _emasLembut,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _kopiTua,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          isReturned ? Icons.calendar_today_outlined : Icons.calendar_month_outlined,
                          size: 16,
                          color: _kopiTua.withOpacity(0.7),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isReturned ? 'Selesai: ${loan['returnDate']}' : 'Jatuh Tempo: ${loan['dueDate']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _kopiTua.withOpacity(0.8),
                            fontWeight: isReturned ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: _kopiTua.withOpacity(0.5),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Map<String, String> _getUserData(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey('userName')) {
      return {
        'name': args['userName'] ?? 'Pengguna Library App',
        'email': args['userEmail'] ?? 'user.library@gmail.com',
        'bio': 'Suka membaca buku fiksi ilmiah, sejarah, dan mencari inspirasi dari cerita klasik.',
      };
    }
    return {
      'name': 'cinta', 
      'email': 'cinta@gmail.com',
      'bio': 'Penggemar novel klasik dan penulis terkenal. Suka menjelajahi kisah-kisah penuh makna dari seluruh dunia.',
    };
  }
  
  static const List<Map<String, dynamic>> _loanHistory = [
    {'title': 'Laut Bercerita', 'dueDate': '20 Nov 2023', 'returnDate': '20 Nov 2023', 'isReturned': true},
    {'title': 'Cantik Itu Luka', 'dueDate': '15 Des 2023', 'returnDate': '', 'isReturned': false},
    {'title': 'Luka Cita', 'dueDate': '01 Jan 2024', 'returnDate': '28 Des 2023', 'isReturned': true},
    {'title': 'Hello Cello', 'dueDate': '10 Feb 2024', 'returnDate': '', 'isReturned': false},
  ];

  final String _profileImageUrl = 'https://i.mydramalist.com/E5Yrgl_5c.jpg';

  void _handleLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda telah keluar. Kembali ke halaman Login.'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void _handleEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Gabisa Diedit'),
        backgroundColor: _emasLembut,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = _getUserData(context);

    return Scaffold(
      backgroundColor: _kremEmas, 
      
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: _kremEmas,
          ),
        ),
        backgroundColor: _kopiTua, 
        elevation: 4, 
        centerTitle: true,
        iconTheme: const IconThemeData(color: _kremEmas), 
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _emasLembut, width: 3), 
                boxShadow: [
                  BoxShadow(
                    color: _kopiTua.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: _kopiTua, 
                child: ClipOval(
                  child: Image.network(
                    _profileImageUrl, 
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        userData['name']![0].toUpperCase(), 
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: _kremEmas,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              userData['name']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: _kopiTua,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              userData['email']!,
              style: TextStyle(
                fontSize: 16,
                color: _kopiTua.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleEditProfile(context), 
                icon: const Icon(Icons.edit_rounded, color: _kopiTua, size: 20),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: _kopiTua,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kopiTua,
                  side: const BorderSide(color: _kopiTua, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),


            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _emasLembut, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tentang Saya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _kopiTua,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['bio']!,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: _kopiTua.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Pinjaman Saya',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _kopiTua,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ..._loanHistory.map((loan) {
              return LoanHistoryItem(
                loan: loan,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Melihat detail riwayat: ${loan['title']}'),
                      backgroundColor: _kopiTua,
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                },
              );
            }).toList(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded, color: _kremEmas),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: _kremEmas
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _kopiTua,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const MyNavBar(2),
    );
  }
}