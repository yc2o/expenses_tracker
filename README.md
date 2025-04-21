# **Expenses Tracker**

## **Deskripsi**
**Expenses Tracker** adalah aplikasi berbasis Flutter yang dirancang untuk membantu pengguna melacak pengeluaran harian mereka. Aplikasi ini memungkinkan pengguna mencatat transaksi, mengelola kategori pengeluaran, dan menganalisis data keuangan untuk pengelolaan keuangan yang lebih baik.

---

## **Fitur**
- **Tambah Transaksi**:
  - Catat pengeluaran atau pemasukan dengan deskripsi, kategori, jumlah, dan tanggal.
  - Validasi input untuk memastikan data yang dimasukkan benar.
- **Edit Transaksi**:
  - Ubah detail transaksi yang sudah tercatat, termasuk kategori, jumlah, dan tanggal.
- **Hapus Transaksi**:
  - Geser transaksi ke kiri untuk menghapusnya.
- **Kategori Transaksi**:
  - Pilih kategori seperti "Makanan", "Hiburan", "Belanja", dll.
- **Format Tanggal Dinamis**:
  - Tampilkan tanggal transaksi dengan format seperti "Hari ini", "Kemarin", atau "7 hari lalu".
- **Statistik Pengeluaran** *(Opsional jika ada)*:
  - Analisis pengeluaran berdasarkan kategori atau rentang waktu tertentu.
- **UI Modern**:
  - Desain antarmuka yang responsif dengan gradasi warna dan elemen yang menarik.

---

## **Struktur Proyek**
```bash
expenses_tracker/
├── lib/
│   ├── helpers/
│   │   └── database_helper.dart   # Logika untuk SQLite (CRUD)
│   ├── models/
│   │   └── transaction.dart       # Model data transaksi
│   ├── screens/
│   │   ├── add_expense.dart       # Halaman untuk menambah transaksi
│   │   ├── edit_expense.dart      # Halaman untuk mengedit transaksi
│   │   └── main_screen.dart       # Halaman utama untuk daftar transaksi
├── pubspec.yaml                   # Konfigurasi dependensi Flutter
├── README.md                      # Dokumentasi proyek
└── ...
```

## **Teknologi yang Digunakan**
- **Frontend**: Flutter
- **Database**: SQLite (melalui `sqflite` package)
- **State Management**: Stateful Widgets (untuk pengelolaan UI dinamis)
- **Format Tanggal**: `intl` package untuk format tanggal dan mata uang.

---

## **Cara Menjalankan Proyek**
1. **Clone Repository**:
   ```
   git clone https://github.com/yc2o/expenses_tracker.git
   cd expenses_tracker
   ```
   2. **Install Dependensi**:
   Jalankan perintah berikut untuk menginstal semua dependensi yang diperlukan:
   ```
   flutter pub get
   ```

3. **Jalankan Aplikasi**:
   Jalankan aplikasi di emulator atau perangkat fisik:
   ```
   flutter run
   ```

4. **Build untuk Produksi** *(Opsional)*:
   Untuk membangun aplikasi dalam mode produksi:
   ```
   flutter build apk
   ```

---

## **Struktur Database**
Tabel `transactions` digunakan untuk menyimpan data transaksi. Berikut adalah struktur tabelnya:
- **id**: Primary key (integer, auto-increment).
- **name**: Nama transaksi (text).
- **category**: Kategori transaksi (text).
- **type**: Jenis transaksi (`Expense` atau `Income`).
- **amount**: Jumlah transaksi (real).
- **date**: Tanggal transaksi (text, ISO 8601 format).
- **created_at**: Tanggal pencatatan transaksi (text, ISO 8601 format).

---

## **Kontribusi**
Kontribusi sangat diterima! Jika Anda ingin menambahkan fitur baru, memperbaiki bug, atau meningkatkan dokumentasi, silakan buat **pull request** atau buka **issue** di repository ini.

### **Langkah Kontribusi**:
1. Fork repository ini.
2. Buat branch baru untuk fitur atau perbaikan Anda:
   ```
   git checkout -b fitur-baru
   ```
3. Commit perubahan Anda:
   ```
   git commit -m "Menambahkan fitur baru"
   ```
4. Push branch Anda:
   ```
   git push origin fitur-baru
   ```
5. Buat pull request di GitHub.

---

## **Lisensi**
Proyek ini dilisensikan di bawah MIT License.

---

Jika ada pertanyaan atau masalah, jangan ragu untuk menghubungi kami melalui **Issues** di repository ini.