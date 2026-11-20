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
- `lib/screens/menu.dart` memisahkan halaman utama dari titik masuk aplikasi
  (sebelum refactoring Tutorial 09: `lib/menu.dart`).
  `MyHomePage` menggunakan `StatelessWidget` karena halaman tidak menyimpan
  state lokal yang berubah.
- `InfoCard` menerima `title` dan `content` untuk menampilkan NPM, nama,
  dan kelas tanpa mengulang definisi widget kartu.
- `ItemHomepage` menyimpan nama, ikon, serta warna menu. Daftar ini ditampilkan
  melalui `ItemCard` di dalam `GridView.count` dengan tiga kolom.
- Tombol **Lihat Proyek**, **Tambah Proyek**, dan **Logout** menggunakan
  `InkWell`. Setiap tombol menampilkan pesan
  `Kamu telah menekan tombol <nama tombol>!` melalui `SnackBar`.
  Pada tahap Tutorial 08/Tugas 7 tombol belum melakukan navigasi, penambahan
  data, atau logout. Navigasi Tambah Proyek ditambahkan pada Tutorial 09.
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

   | Widget                  | Fungsi dalam proyek                                                |
   | ----------------------- | ------------------------------------------------------------------ |
   | `MyApp`                 | Widget buatan proyek yang menyiapkan konfigurasi aplikasi.         |
   | `MaterialApp`           | Menetapkan judul, tema, dan halaman awal aplikasi Material.        |
   | `MyHomePage`            | Menyusun halaman profil dan menu portofolio.                       |
   | `Scaffold`              | Menyediakan kerangka halaman dengan app bar dan body.              |
   | `AppBar`                | Menampilkan judul MyPortfolio di bagian atas.                      |
   | `SingleChildScrollView` | Membuat body bisa digulir ketika melebihi tinggi layar.            |
   | `Padding`               | Memberi ruang di sekitar isi widget.                               |
   | `Column`                | Menyusun bagian halaman serta isi kartu secara vertikal.           |
   | `Row`                   | Menyusun tiga kartu profil secara horizontal.                      |
   | `Expanded`              | Membagi lebar yang tersedia secara merata untuk kartu profil.      |
   | `InfoCard`              | Komponen buatan proyek untuk satu pasangan label dan nilai profil. |
   | `Card`                  | Memberi permukaan kartu dan elevasi pada informasi profil.         |
   | `Text`                  | Menampilkan judul, identitas, label tombol, dan pesan.             |
   | `SizedBox`              | Memberi jarak vertikal antarbagian.                                |
   | `Center`                | Menempatkan anak di tengah ruang yang tersedia.                    |
   | `GridView.count`        | Menyusun tiga kartu aksi dalam tiga kolom.                         |
   | `ItemCard`              | Komponen buatan proyek untuk satu aksi portofolio.                 |
   | `Material`              | Menyediakan permukaan berwarna dan tempat efek tinta tombol.       |
   | `InkWell`               | Menangani tap serta memberi umpan balik sentuhan.                  |
   | `Icon`                  | Menampilkan simbol folder, tambah, dan logout.                     |
   | `SnackBar`              | Menampilkan pesan sementara sesuai tombol yang ditekan.            |

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

## Tutorial 09: Navigation, Layouts, Forms, and Input Elements

Implementasi mengikuti [Tutorial 09](https://pbp.cs.ui.ac.id/tutorial/tutorial-9.html)
dengan mempertahankan identitas PBP F, nama lengkap, NPM, dan warna kartu Tugas 7.

### Setup dan struktur

Flutter yang digunakan untuk verifikasi: **3.47.9**, dengan Dart **3.13.7**.
Dependensi `material_ui` **1.11.1** ditambahkan sesuai petunjuk tutorial dan
semua impor Material pada aplikasi serta tes menggunakan
`package:material_ui/material_ui.dart`. Paket ini mendukung SDK yang terpasang,
sehingga tidak diperlukan upgrade Flutter. `pubspec.lock` mencatat versi yang
diuji. Setelah checkout branch, jalankan `flutter pub get` sebelum menjalankan
aplikasi atau tes. Rujukan migrasi: [paket resmi material_ui](https://pub.dev/packages/material_ui).

```text
lib/
├── main.dart
├── screens/
│   ├── menu.dart
│   └── project_form.dart
└── widgets/
    ├── left_drawer.dart
    └── project_card.dart
```

`main.dart` tetap menjadi titik masuk. `MyHomePage`, `InfoCard`, dan model
`ItemHomepage` berada di `screens/menu.dart`; `ItemCard` dipisahkan ke
`widgets/project_card.dart`. Seluruh impor aplikasi dan tes telah disesuaikan.

### Implementasi dan alur penggunaan

- `LeftDrawer` tersedia pada halaman utama dan form, dengan header, pilihan
  **Home**, dan **Add Project**. Pemilihan menu menutup drawer lalu menggunakan
  `Navigator.pushReplacement`, sehingga mengganti route aktif.
- Kartu **Tambah Proyek** tetap menampilkan SnackBar lalu menggunakan
  `Navigator.push` untuk membuka `ProjectFormPage`. Route sebelumnya tetap ada
  untuk navigasi kembali. **Lihat Proyek** dan **Logout** masih berupa SnackBar.
- `ProjectFormPage` adalah `StatefulWidget` yang mempertahankan `GlobalKey<FormState>`
  dan nilai isian selama halaman aktif. `Form` di dalam halaman berisi nama
  proyek, deskripsi lima baris, kategori, teknologi, dan tautan opsional.
- Nama dan deskripsi menolak input kosong maupun spasi saja. Kategori menggunakan
  `DropdownButtonFormField.initialValue` dengan default **Web Development**;
  pilihannya juga mencakup Mobile Development, Machine Learning, Data Science,
  dan Other. Teknologi dan tautan dapat dikosongkan; tautan belum divalidasi
  sebagai URL karena tutorial hanya meminta input teks opsional.
- **Save** menjalankan validasi. Jika valid, `AlertDialog` menampilkan kelima
  nilai. **OK** menutup dialog dengan `Navigator.pop`, mereset field, dan
  mengosongkan variabel isian serta mengembalikan kategori default. Reset juga
  diuji melalui pengiriman kedua agar data lama tidak terbawa.
- Form, isi dialog, dan isi header drawer dapat digulir untuk mencegah konten
  panjang terpotong. Dropdown memakai `isExpanded` agar muat pada layar sempit.

Teks konfirmasi mengikuti tutorial, tetapi **belum ada penyimpanan data**, daftar
proyek tersimpan, autentikasi, atau integrasi API Django. Menutup halaman
menghilangkan isian. Form Edukasi ditambahkan pada tahap Tugas 8 di bawah.

### Verifikasi Tutorial 09

Pemeriksaan pada **17 November 2026**:

- `dart format --output=none --set-exit-if-changed lib test halo_burhan.dart`: bersih.
- `flutter analyze --no-pub`: **No issues found**.
- `flutter test --no-pub`: **11 tes lulus**.
- `flutter build web --no-pub`: build rilis web berhasil; Wasm dry run berhasil.
- `git diff --check`: bersih; tidak ada komentar TODO dalam `lib/` dan `test/`.
- Uji browser lokal: membuka form dari kartu, menolak isian wajib kosong,
  memasukkan data, menampilkan kelima nilai di dialog, mereset setelah OK,
  dan kembali ke Home melalui drawer.

Tes otomatis mencakup profil/warna Tugas 7, SnackBar, layout halaman utama pada
320×568, 390×844, dan 1440×900, push dan kembali, replacement melalui drawer,
validasi spasi, pengiriman ulang setelah reset, serta form/dialog panjang pada
layar 320×568. Tombol kembali diuji melalui event `handlePopRoute`; tombol Back
browser dan perangkat fisik belum diuji tersendiri. Build Android/iOS dan hot
reload juga belum diverifikasi dalam tahap ini.

### Git, pengumpulan, dan bantuan AI

Pekerjaan dilakukan pada branch `tutorial/09-navigation-forms` dari `main`
terbaru, dengan commit Conventional Commits bertahap dan pull request ke `main`.
PR dibiarkan terbuka untuk ditinjau sesuai arahan pemilik. Riwayat sebelumnya
dipertahankan; `main` tidak diubah langsung.

Prompt tahap ini: “continue tutorial 9”, disertai isi panduan lengkap dan
instruksi sebelumnya untuk memakai branch serta PR. Codex membantu memigrasikan
impor, memisahkan file, mengimplementasikan form/navigasi, menulis tes, melakukan
verifikasi browser, dan memperbarui dokumentasi. Penyesuaian terhadap contoh
meliputi reset variabel agar tidak menyisakan nilai lama dan header yang dapat
digulir setelah tes menemukan overflow. Pemindahan file serta pembaruan impor
dilakukan melalui alat penyuntingan otomatis dan diverifikasi dengan analyzer,
bukan melalui dialog rename IDE. Tautan chat Tutorial 08 di atas tetap
merupakan riwayat tahap awal, bukan ekspor lengkap percakapan Tutorial 09.


### Tugas 8

1. **Navigasi dan tumpukan halaman.** `Navigator.push()` menambahkan route baru
   di atas route aktif. Kartu **Tambah Edukasi** memakai metode ini dengan
   `MaterialPageRoute` menuju `EducationFormPage`, sehingga route Home tetap
   tersedia untuk tombol kembali perangkat. `Navigator.pop()` menghapus route
   teratas; pada tombol **Tutup**, context dialog dipakai untuk menutup dialog
   dan menampilkan form lagi. `Navigator.pushReplacement()` mengganti route
   teratas, bukan mengosongkan seluruh riwayat. Opsi **Home** pada `LeftDrawer`
   terlebih dahulu menutup drawer dengan `pop()`, lalu mengganti halaman aktif
   dengan `MyHomePage` melalui `pushReplacement()`. Alur ini juga menyediakan
   jalan kembali ke Home saat aplikasi berjalan di browser. Rujukan:
   [Navigator Flutter](https://api.flutter.dev/flutter/widgets/Navigator-class.html).

2. **Struktur halaman yang konsisten.** `Scaffold` menyediakan kerangka halaman,
   `AppBar` menampilkan judul dan akses drawer, sedangkan `LeftDrawer` yang sama
   digunakan oleh Home, Tambah Proyek, dan Tambah Edukasi. Opsi **Home** dan
   **Add Project** dipertahankan, lalu **Add Education** ditambahkan. AppBar Home
   dan Edukasi sama-sama mengambil `Theme.of(context).colorScheme.primary`;
   tombol **Simpan** Edukasi juga memakai warna tersebut dengan teks
   `colorScheme.onPrimary`. Karena memakai tema aplikasi, perubahan warna tema
   dapat diterapkan konsisten tanpa menyalin nilai warna ke setiap halaman.

3. **Layout formulir.** Form memakai `Column` agar tiga input dibaca dari atas
   ke bawah. `SingleChildScrollView` membuat input dan tombol tetap dapat
   dijangkau ketika tinggi layar berkurang, termasuk saat papan ketik muncul.
   `Scaffold` mempertahankan perilaku default untuk menyesuaikan ruang badan
   halaman terhadap keyboard. Padding 16 memberi jarak dari tepi layar,
   `SizedBox` memisahkan input, dan `CrossAxisAlignment.stretch` membuat input
   serta tombol mengikuti lebar ruang yang tersedia. Dropdown memakai
   `isExpanded: true` agar label tidak melampaui lebar input. Dialog menggunakan
   `scrollable: true` supaya ringkasan panjang tetap bisa dibaca. Tes pada
   320×568 dengan inset keyboard 250 memastikan **Simpan** bisa digulir ke layar.

4. **Validasi sebelum ringkasan.** `GlobalKey<FormState>` disimpan sekali di
   state halaman agar tombol **Simpan** dapat mengakses form yang sama.
   `validate()` menjalankan `validator` setiap field; pesan String menandakan
   kesalahan, sedangkan `null` berarti valid. Jika ada kegagalan, dialog tidak
   dibuka. Setelah semua valid, `save()` mengambil nilai teks yang sudah
   di-`trim()`, lalu `showDialog()` menampilkan seluruh isian. Contohnya,
   institusi berisi `"   "` ditolak karena kosong setelah trim; 256 karakter
   ditolak karena model membatasi 255. Jenjang wajib dipilih dari pilihan model.
   Jenis input atau papan ketik hanya membantu memasukkan data: pengguna masih
   dapat menempelkan teks kosong, terlalu panjang, atau nilai yang tidak sesuai,
   sehingga validator tetap diperlukan. Rujukan:
   [Form validation Flutter](https://docs.flutter.dev/cookbook/forms/validation).

#### Implementasi dan kesesuaian model

Form baru berada di `lib/screens/education_form.dart` sebagai `StatefulWidget`
dengan `Form` dan `GlobalKey<FormState>`. Field mengikuti tiga atribut wajib
model `Education` pada `main/models.py` proyek Django `myportofolio`:

| Input | Atribut model | Widget dan aturan |
| --- | --- | --- |
| Institusi | `institution` | `TextFormField`; wajib setelah trim, maksimal 255 karakter Unicode |
| Jenjang Pendidikan | `degree` | `DropdownButtonFormField<String>`; wajib memilih salah satu `DEGREE_CHOICES` |
| Bidang Studi | `field_of_study` | `TextFormField`; wajib setelah trim, maksimal 255 karakter Unicode |

Pilihan jenjang: `secondary`, `diploma`, `bachelor`, `master`, `doctorate`, dan
`other`, dengan label sesuai model Django. Panjang teks dihitung melalui
`runes.length`, sehingga karakter Unicode di luar BMP tidak dihitung sebagai
dua unit UTF-16. Atribut opsional deskripsi dan website tidak dimasukkan dalam
cakupan form ini; karena tidak ada input URL atau tanggal, validator URL dan
date picker tidak diperlukan. Timestamp model dibuat otomatis oleh backend.

Kartu ungu **Tambah Edukasi** ditambahkan tanpa mengganti tiga kartu sebelumnya.
`ItemCard` tetap berada di `lib/widgets/project_card.dart`, dan navigasi drawer
berada di `lib/widgets/left_drawer.dart`. Dialog menampilkan ketiga isian;
**Tutup** kembali ke form dengan nilai tetap tersedia untuk diedit.
**Simpan hanya menampilkan ringkasan, belum menyimpan ke database atau API.**
Meninggalkan halaman membuang isian form tersebut.

#### Setup dan verifikasi Tugas 8

Tidak ada dependensi baru. Gunakan setup Flutter dan `material_ui` dari Tutorial
09. Pada branch `assignment/08-education-form`, jalankan dari root proyek:

```bash
flutter pub get
flutter run -d chrome
flutter analyze --no-pub
flutter test --no-pub
flutter build web --no-pub
```

Hasil pemeriksaan pada **20 November 2026**:

- Analyzer: **No issues found**; build rilis web dan Wasm dry run berhasil.
- **17 tes lulus**, termasuk enam tes Edukasi: push/kembali, drawer/Home,
  penolakan input kosong dan spasi, batas 255/256 karakter, isi dialog terbaru
  setelah pengeditan, serta akses tombol pada 320×568 dengan inset keyboard.
- Tes profil, warna/SnackBar, layout Home, dan form Proyek sebelumnya tetap lulus.
- Format Dart dan `git diff --check` bersih.
- Browser lokal: membuka Edukasi dari kartu dan drawer, menolak ketiga input
  kosong, menampilkan ringkasan valid, menutup dialog, dan kembali ke Home.
- Layar sempit dan keyboard diverifikasi melalui widget test; browser diuji
  pada viewport desktop. Perangkat Android/iOS fisik belum diuji.

#### Git dan keterbukaan penggunaan AI

Branch dibuat dari `main` terbaru yang sudah mencakup merge Tutorial 09 dan
perubahan README pemilik. Implementasi beserta tes dan dokumentasi dicatat
sebagai commit Conventional Commits bertahap, dipublikasikan pada repositori
publik yang sama, lalu diajukan melalui PR ke `main` untuk ditinjau.

Log prompt tahap ini: **“continue assignment 8”**, disertai checklist dan
pertanyaan reflektif lengkap. Arahan sebelumnya: periksa `main` terbaru,
pertahankan perubahan pemilik, gunakan branch untuk tiap tugas/tutorial,
dan buat pull request seperti proyek Django. Strateginya adalah memeriksa
model Django yang sudah ada, memakai tiga field wajib Edukasi, mengikuti pola
navigasi Tutorial 09, lalu menguji validasi dan layout sebelum publikasi.

**Codex** membantu membaca model, mengimplementasikan form serta navigasi,
menulis dan menjalankan tes, melakukan pemeriksaan browser, serta menyusun
jawaban reflektif dan dokumentasi ini. Tes baru terlebih dahulu menunjukkan
kegagalan karena halaman/navigasi Edukasi belum tersedia, kemudian lulus setelah
implementasi. Catatan ini merupakan ringkasan prompt dan pekerjaan, bukan
transkrip lengkap atau klaim bahwa semua kode telah ditinjau manual oleh pemilik.

Keterbatasan AI: kesesuaian field perlu diperiksa terhadap model nyata, bukan
menebak atribut dari contoh tugas; panjang teks juga perlu memperhatikan Unicode.
Validasi sisi Flutter belum menggantikan validasi server saat integrasi API
nanti dibuat. Hasil tes otomatis dan browser tidak membuktikan perilaku seluruh
perangkat, dan tidak membuktikan pengumpulan melalui SCELE.
