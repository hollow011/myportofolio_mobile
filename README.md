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
Fondasi Tutorial 08 dilanjutkan dengan personalisasi untuk Tugas 7.
Halaman memakai identitas pemilik repositori. Aplikasi belum terhubung ke API Django.

### Implementasi

- `lib/main.dart` berisi fungsi `main()`, `MyApp`, dan konfigurasi `MaterialApp`.
  Tema Material 3 memakai warna dasar indigo dan warna sekunder amber.
- `lib/menu.dart` memisahkan halaman utama dari titik masuk aplikasi.
  `MyHomePage` menggunakan `StatelessWidget` karena halaman tidak menyimpan
  state lokal yang berubah.
- `InfoCard` menerima `title` dan `content` untuk menampilkan NPM, nama,
  dan kelas tanpa mengulang definisi widget kartu.
- `ItemHomepage` menyimpan nama, ikon, serta warna menu. Daftar ini ditampilkan
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

### Tugas 7

Implementasi mengikuti [Individual Assignment 7](https://pbp.cs.ui.ac.id/assignments/individual/tugas-7.html).
Profil menggunakan nama lengkap Mohammad Adzka Aulia, NPM 2506657005, dan
kelas PBP F yang dikonfirmasi pemilik. Tiga tombol tetap menampilkan SnackBar:
Lihat Proyek berwarna biru, Tambah Proyek hijau, dan Logout merah. Warna shade
800 dipilih agar teks putih tetap terbaca. `ItemHomepage.color` menyimpan warna
masing-masing menu; `ItemCard` memakainya langsung tanpa percabangan nama tombol.

1. **Apa itu widget tree dan bagaimana hubungan parent-child bekerja?**

   Widget tree adalah susunan hierarkis widget yang mendeskripsikan antarmuka.
   Widget induk menyusun widget anak melalui properti seperti `child`, `children`,
   atau `home`. Contohnya, `MyApp` membangun `MaterialApp`, `home` menampilkan
   `MyHomePage`, lalu halaman tersebut membangun `Scaffold`. Di dalam body,
   `Column` memiliki anak berupa baris profil, jarak, dan bagian menu.

   Induk memberikan konfigurasi kepada anak. Contohnya, `MyHomePage` mengirim
   `title` dan `content` ke `InfoCard`, sedangkan `ItemCard` menerima satu
   `ItemHomepage`. Dalam proses layout, constraints mengalir dari induk ke anak,
   anak menentukan ukuran sesuai constraints, dan induk menentukan posisinya.
   Widget adalah deskripsi immutable; Flutter memakai element dan render object
   di baliknya untuk mempertahankan identitas, menghitung layout, dan menggambar.
   Rebuild tidak berarti seluruh layar selalu digambar ulang dari nol.
   Lihat [pengantar UI Flutter](https://docs.flutter.dev/ui).

2. **Widget apa saja yang digunakan dan apa fungsinya?**

   Berikut widget yang digunakan secara langsung dalam kode aplikasi:

   | Widget | Fungsi dalam proyek |
   | --- | --- |
   | `MyApp` | Widget buatan proyek yang menyiapkan konfigurasi aplikasi. |
   | `MaterialApp` | Menetapkan judul, tema, dan halaman awal aplikasi Material. |
   | `MyHomePage` | Menyusun halaman profil dan menu portofolio. |
   | `Scaffold` | Menyediakan kerangka halaman dengan app bar dan body. |
   | `AppBar` | Menampilkan judul MyPortfolio di bagian atas. |
   | `SingleChildScrollView` | Membuat body bisa digulir ketika melebihi tinggi layar. |
   | `Padding` | Memberi ruang di sekitar isi widget. |
   | `Column` | Menyusun bagian halaman serta isi kartu secara vertikal. |
   | `Row` | Menyusun tiga kartu profil secara horizontal. |
   | `Expanded` | Membagi lebar yang tersedia secara merata untuk kartu profil. |
   | `InfoCard` | Komponen buatan proyek untuk satu pasangan label dan nilai profil. |
   | `Card` | Memberi permukaan kartu dan elevasi pada informasi profil. |
   | `Text` | Menampilkan judul, identitas, label tombol, dan pesan. |
   | `SizedBox` | Memberi jarak vertikal antarbagian. |
   | `Center` | Menempatkan anak di tengah ruang yang tersedia. |
   | `GridView.count` | Menyusun tiga kartu aksi dalam tiga kolom. |
   | `ItemCard` | Komponen buatan proyek untuk satu aksi portofolio. |
   | `Material` | Menyediakan permukaan berwarna dan tempat efek tinta tombol. |
   | `InkWell` | Menangani tap serta memberi umpan balik sentuhan. |
   | `Icon` | Menampilkan simbol folder, tambah, dan logout. |
   | `SnackBar` | Menampilkan pesan sementara sesuai tombol yang ditekan. |

   `Theme` dan `ScaffoldMessenger` juga digunakan melalui `.of(context)` untuk
   memperoleh tema dan pengelola SnackBar dari ancestor. Keduanya tidak dibuat
   secara eksplisit dalam kode halaman; infrastruktur aplikasi menyediakannya.
   `ItemHomepage` adalah model data, bukan widget. `ColorScheme`, `TextStyle`,
   `EdgeInsets`, `BorderRadius`, dan `NeverScrollableScrollPhysics` merupakan
   objek konfigurasi, bukan widget. `StatelessWidget` adalah kelas dasar bagi
   keempat widget buatan proyek di atas.

3. **Apa fungsi MaterialApp dan mengapa biasanya berada di root?**

   `MaterialApp` menggabungkan fasilitas yang umum dibutuhkan aplikasi Material,
   termasuk tema, navigasi halaman, serta konfigurasi bahasa dan arah teks.
   Dengan menempatkannya dekat root, halaman-halaman di bawahnya dapat memakai
   konfigurasi yang konsisten. Dalam proyek ini, `title` adalah MyPortfolio,
   `theme` memakai Material 3 dengan seed indigo, dan `home` adalah `MyHomePage()`.

   Secara tepat, widget yang diberikan ke `runApp` adalah `MyApp`; `MaterialApp`
   dikembalikan oleh `MyApp.build`. Jadi `MaterialApp` berada dekat root, bukan
   harus selalu menjadi objek yang langsung diberikan ke `runApp`. Flutter juga
   menyediakan alternatif seperti `CupertinoApp` atau `WidgetsApp`, bergantung
   pada kebutuhan aplikasi. Lihat [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

4. **Apa perbedaan StatelessWidget dan StatefulWidget?**

   `StatelessWidget` tidak memiliki objek `State` untuk menyimpan state lokal
   yang berubah. Tampilannya bergantung pada konfigurasi dan context. Namun,
   stateless bukan berarti hanya dibangun sekali: widget dapat dibangun ulang
   ketika induknya memberikan konfigurasi baru atau dependensi seperti tema
   berubah. `InfoCard` dan `ItemCard` cocok memakai jenis ini karena menerima
   data lalu menampilkannya. Lihat [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html).

   `StatefulWidget` juga immutable, tetapi mempunyai objek `State` terpisah
   yang dapat menyimpan data berubah, misalnya jumlah klik, pilihan filter, atau
   status memuat data. `setState` memberi tahu framework bahwa perubahan state
   memerlukan rebuild. Pilih jenis ini ketika widget perlu mengelola perubahan
   tersebut selama masa hidupnya. Lihat [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).

   `MyHomePage` tetap stateless karena profil dan daftar menunya tidak berubah
   akibat tap. Menampilkan SnackBar tidak mengharuskan halaman menjadi stateful:
   state pesan dikelola oleh `ScaffoldMessenger`, bukan oleh halaman.

5. **Apa itu BuildContext dan bagaimana penggunaannya di build?**

   `BuildContext` adalah pegangan ke lokasi suatu widget dalam tree. Parameter
   `context` pada `Widget build(BuildContext context)` memungkinkan widget
   mencari fasilitas ancestor yang relevan. Dalam proyek ini,
   `Theme.of(context).colorScheme.primary` mengambil warna tema untuk AppBar.
   Pada callback tombol, `ScaffoldMessenger.of(context)` memperoleh pengelola
   pesan, menyembunyikan SnackBar sebelumnya, lalu menampilkan pesan baru.

   Lokasi context menentukan hasil pencarian: ia mencari ke atas melalui
   ancestor, bukan ke anak yang baru dikembalikan oleh metode `build` tersebut.
   Karena itu, context harus berada di bawah provider yang dibutuhkan. Jika
   mengakses context setelah operasi asynchronous, periksa `context.mounted`
   sebelum menggunakannya. Lihat [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Apa perbedaan hot reload, hot restart, dan full restart?**

   Hot reload memasukkan perubahan kode Dart dan membangun ulang tampilan sambil
   mempertahankan state aplikasi. Ini cocok untuk mengubah teks, warna, dan
   susunan widget saat pengembangan. Hot reload tidak menjalankan ulang `main()`
   atau `initState()`, sehingga perubahan logika inisialisasi tidak selalu terlihat.

   Hot restart memulai ulang aplikasi Flutter dan menghilangkan state yang ada;
   `main()` serta inisialisasi state dijalankan kembali. Gunakan ketika perlu
   mengulang inisialisasi, mereset state, atau setelah perubahan struktur tipe
   tertentu yang tidak didukung hot reload, seperti perubahan parameter generic.

   Full restart menghentikan dan menjalankan aplikasi kembali, termasuk proses
   kompilasi platform bila diperlukan. Perubahan kode native seperti Kotlin,
   Java, Swift, atau Objective-C memerlukan langkah ini; hot restart hanya pada
   sisi Flutter tidak cukup. Keduanya bukan pengganti pengujian build rilis.
   Hot reload dan hot restart tersedia untuk pengembangan dalam debug mode.
   Lihat [panduan hot reload](https://docs.flutter.dev/tools/hot-reload).


### Pemeriksaan

```sh
flutter analyze
flutter test
flutter build web
```

Pemeriksaan pada 15 November 2026: format Dart bersih, `flutter analyze --no-pub`
melaporkan **No issues found**, keenam tes pada `flutter test --no-pub` lulus,
dan `flutter build web --no-pub` berhasil menghasilkan `build/web`.
Opsi `--no-pub` memakai dependensi yang sudah tersedia; instalasi baru tetap
perlu menjalankan `flutter pub get` terlebih dahulu.
Tes mencakup identitas pemilik, tiga warna kartu yang berbeda dengan kontras
teks putih minimal 4,5:1, pesan ketiga tombol, penggantian SnackBar, dan
layout pada ukuran 320×568, 390×844, serta 1440×900. Tinggi kartu aksi
ditambah menjadi 140 agar label yang membungkus tidak melampaui kartu.
Runtime interaktif di peramban, hot reload, serta build dan pengujian
Android/iOS belum diverifikasi pada tahap ini.

### Penggunaan AI

ChatGPT Codex digunakan untuk membaca panduan Tutorial 08, membuat struktur
proyek Flutter, menyusun widget halaman dan tes, menyesuaikan layout,
menjalankan pemeriksaan yang tersedia, serta menyusun README.
Riwayat Chat: https://chatgpt.com/share/6af470e5-7b8c-83ec-a674-d4c284b07c5b

Pada Tugas 7, Codex membantu memperbarui profil, menambahkan warna pada model
menu, memperbaiki tes, menelusuri overflow layar kecil, dan menyusun jawaban
reflektif dengan rujukan dokumentasi Flutter. Pemilik mengonfirmasi kelas
PBP F; perubahan nama tampilan dan NPM pada commit sebelumnya berasal dari
pemilik. Tautan chat di atas berasal dari tahap Tutorial 08, bukan bukti bahwa
percakapan Tugas 7 sudah tercakup.

Keterbatasan AI terlihat pada fondasi awal: tes masih memakai profil contoh dan
layout layar kecil belum terbukti aman saat runner sebelumnya terblokir. Pada
tahap ini tes dijalankan kembali agar kesimpulan didasarkan pada hasil aktual.
Jawaban reflektif dibantu AI dan perlu dipahami oleh pemilik; dokumentasi ini
tidak mengklaim review manual seluruh kode, pengujian perangkat fisik, atau
submisi SCELE yang belum dibuktikan.

### Ringkasan Prompt

- “an extension off the 'Continue PBP Dev' but for flutter. do the tasks from
  the tutorial”, disertai halaman Tutorial 08.
- Tautan Tutorial 08 diberikan kembali untuk memastikan spesifikasi yang diikuti.
- Tugas 7: “continue”, disertai halaman tugas lengkap, lalu klarifikasi kelas
  “PBP F”. Lingkupnya adalah checklist tugas, enam jawaban README, dan verifikasi.

### Strategi Prompting

- Memberikan materi tutorial dan konteks proyek web sebelumnya.
- Meminta implementasi langsung pada repositori Flutter yang terpisah.
- Menggunakan README proyek web sebagai acuan struktur dokumentasi mobile.
- Membedakan pemeriksaan yang lulus dari pengujian yang belum dapat dijalankan.
