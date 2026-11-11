# My Portfolio Mobile

Aplikasi mobile portofolio Mohammad Adzka Aulia untuk mata kuliah
Pemrograman Berbasis Platform (PBP). Proyek ini dibangun menggunakan Flutter
dan Dart sebagai kelanjutan versi web
[My Portfolio](https://github.com/hollow011/myportofolio).

## Identitas

- Nama: Mohammad Adzka Aulia
- NPM: 2506657005
- Kelas: PBP F

## Menjalankan Proyek

1. Pasang Flutter SDK dan pastikan `flutter` tersedia pada PATH.
2. Periksa konfigurasi perangkat dengan `flutter doctor`.
3. Masuk ke direktori proyek dan instal dependensi:

   ```sh
   cd myportofolio_mobile
   flutter pub get
   ```

4. Lihat perangkat yang tersedia dengan `flutter devices`.
5. Jalankan aplikasi pada Google Chrome:

   ```sh
   flutter run -d chrome
   ```

Untuk Android, pasang Android Studio beserta Android SDK dan Command-line
Tools. Tinjau lisensi melalui `flutter doctor --android-licenses`, lalu jalankan
emulator atau hubungkan perangkat dengan USB debugging dan gunakan `flutter run`.
Peramban lain dapat memakai `flutter run -d web-server`, kemudian membuka URL
yang ditampilkan di terminal.

## Tutorial 08: Basic Flutter

Implementasi mengikuti
[Tutorial 08](https://pbp.cs.ui.ac.id/tutorial/tutorial-8.html).
Halaman awal masih memakai identitas contoh Burhan sesuai tutorial. Identitas
pemilik repositori tercantum di atas; personalisasi halaman untuk Tugas 7 belum
dikerjakan. Aplikasi juga belum terhubung ke API Django.

### Implementasi

- `lib/main.dart` berisi fungsi `main()`, `MyApp`, dan konfigurasi `MaterialApp`.
  Tema Material 3 memakai warna dasar indigo dan warna sekunder amber.
- `lib/menu.dart` memisahkan halaman utama dari titik masuk aplikasi.
  `MyHomePage` menggunakan `StatelessWidget` karena halaman tidak menyimpan
  state lokal yang berubah.
- `InfoCard` menerima `title` dan `content` untuk menampilkan NPM, nama,
  dan kelas tanpa mengulang definisi widget kartu.
- `ItemHomepage` menyimpan nama serta ikon menu. Daftar ini ditampilkan
  melalui `ItemCard` di dalam `GridView.count` dengan tiga kolom.
- Tombol **Lihat Proyek**, **Tambah Proyek**, dan **Logout** menggunakan
  `InkWell`. Setiap tombol menampilkan pesan
  `Kamu telah menekan tombol <nama tombol>!` melalui `SnackBar`.
  Pada tahap ini tombol belum melakukan navigasi, penambahan data, atau logout.
- `Scaffold`, `AppBar`, `Padding`, `Column`, dan `Row` menyusun halaman.
  `Expanded` membagi lebar kartu informasi sesuai ruang yang tersedia;
  `SingleChildScrollView` membuat halaman dapat digulir pada layar pendek.
- `halo_burhan.dart` berisi latihan awal Dart dan dapat dijalankan dengan
  `dart run halo_burhan.dart`.

### Pemeriksaan

```sh
flutter analyze
flutter test
flutter build web
```

Analisis statis selesai tanpa masalah, format Dart sudah diperiksa, dan build
rilis web berhasil. Latihan Dart juga menghasilkan pesan sesuai tutorial.
Tes widget disiapkan untuk memeriksa profil, pesan ketiga tombol, penggantian
SnackBar, dan layout pada ukuran ponsel serta desktop.

Tes widget belum berhasil dijalankan karena lingkungan pengerjaan menolak
socket lokal yang dibutuhkan test runner. Uji interaktif serta build Android/iOS
juga belum diverifikasi. Android SDK dan Chrome belum tersedia pada perangkat
saat pemeriksaan; jalankan kembali perintah di atas setelah setup selesai.

### Penggunaan AI

ChatGPT Codex digunakan untuk membaca panduan Tutorial 08, membuat struktur
proyek Flutter, menyusun widget halaman dan tes, menyesuaikan layout,
menjalankan pemeriksaan yang tersedia, serta menyusun README.
Riwayat Chat: https://chatgpt.com/share/6af470e5-7b8c-83ec-a674-d4c284b07c5b

### Ringkasan Prompt

- “an extension off the 'Continue PBP Dev' but for flutter. do the tasks from
  the tutorial”, disertai halaman Tutorial 08.
- Tautan Tutorial 08 diberikan kembali untuk memastikan spesifikasi yang diikuti.

### Strategi Prompting

- Memberikan materi tutorial dan konteks proyek web sebelumnya.
- Meminta implementasi langsung pada repositori Flutter yang terpisah.
- Menggunakan README proyek web sebagai acuan struktur dokumentasi mobile.
- Membedakan pemeriksaan yang lulus dari pengujian yang belum dapat dijalankan.
