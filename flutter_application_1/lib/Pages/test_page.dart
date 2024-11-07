import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class StorageListPage extends StatefulWidget {
  const StorageListPage({super.key});

  @override
  _StorageListPageState createState() => _StorageListPageState();
}

class _StorageListPageState extends State<StorageListPage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isListVisible = false;
  bool isDownloading = false;
  String searchQuery = '';
  Map<String, double> downloadProgress = {};
  final Dio dio = Dio();

  final String bucketUrl =
      "https://firebasestorage.googleapis.com/v0/b/safeviewbd.appspot.com/o";
  // dotenv.env['BUCKET_URL'] ?? '';

  Future<void> fetchItems() async {
    print('Fetching items from: $bucketUrl');
    final response = await http.get(Uri.parse(bucketUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Verifica que o item tem um campo 'name' e aplica o filtro 'Reports'
      final List<Map<String, dynamic>> fetchedItems = (data['items'] as List)
          .where((item) =>
              item['name'] != null && item['name'].contains("Reports"))
          .map((item) => {
                'name': item['name'],
                'downloadUrl':
                    '$bucketUrl/${Uri.encodeComponent(item['name'])}?alt=media',
              })
          .toList();

      setState(() {
        items = fetchedItems;
        filteredItems = fetchedItems;
        isListVisible = true;
      });

      print('Items fetched successfully: ${fetchedItems.length} items');
    } else {
      print('Error fetching items: ${response.statusCode}');
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    print('Attempting to download file: $fileName from URL: $url');
    try {
      dio.options.responseType = ResponseType.bytes;
      dio.options.headers = {
        'Accept': 'application/pdf',
      };

      final downloadsPath = path.join(Directory.current.path);

      String finalFileName = fileName;
      if (!finalFileName.toLowerCase().endsWith('.pdf')) {
        finalFileName += '.pdf';
      }

      final savePath = path.join(downloadsPath, finalFileName);
      print('Saving file to: $savePath');

      if (await File(savePath).exists()) {
        print('File already exists: $savePath');
        final shouldOverwrite = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Arquivo já existe'),
            content: Text(
                'O arquivo "$finalFileName" já existe. Deseja sobrescrever?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sobrescrever'),
              ),
            ],
          ),
        );

        if (shouldOverwrite != true) {
          print('User chose not to overwrite the file');
          return;
        }
      }

      setState(() {
        downloadProgress[fileName] = 0;
      });

      final response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress[fileName] = (received / total * 100);
            });
          }
        },
      );

      if (response.data == null || response.data.length == 0) {
        throw Exception('Arquivo vazio ou inválido');
      }

      final file = File(savePath);
      await file.writeAsBytes(response.data);

      setState(() {
        downloadProgress.remove(fileName);
      });

      print('Download completed: $finalFileName saved at $savePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Download concluído'),
                    Text(
                      'Salvo em: $savePath',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  final directory = File(savePath).parent;
                  await Process.run('explorer', [directory.path]);
                },
                child: const Text('ABRIR PASTA',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        downloadProgress.remove(fileName);
      });

      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer download: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterItems(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = items
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleListVisibility() {
    if (isListVisible) {
      setState(() {
        isListVisible = false;
        filteredItems = [];
      });
    } else {
      fetchItems();
    }
  }

  void openFileContent(String downloadUrl, String fileName) async {
    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode == 200) {
      final fileData = response.bodyBytes;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FileContentScreen(fileName: fileName, fileData: fileData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar conteúdo do arquivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storage, color: Colors.white),
            SizedBox(width: 8),
            Text('Itens do Bucket Firebase'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterItems,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: toggleListVisibility,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                elevation: 2,
              ),
              child: Text(isListVisible
                  ? 'Ocultar Itens do Bucket'
                  : 'Mostrar Itens do Bucket'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isListVisible
                  ? ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: getFileIcon(item['name']),
                            title: GestureDetector(
                              onTap: () => openFileContent(
                                  item['downloadUrl'], item['name']),
                              child: Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            trailing: isDownloading
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () => downloadFile(
                                        item['downloadUrl'], item['name']),
                                    child: const Text('Download'),
                                  ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Pressione "Mostrar" para exibir os itens',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Icon getFileIcon(String fileName) {
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return const Icon(Icons.picture_as_pdf, color: Colors.red);
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png') ||
        fileName.toLowerCase().endsWith('.gif')) {
      return const Icon(Icons.image, color: Colors.blue);
    } else {
      return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }
}

class FileContentScreen extends StatelessWidget {
  final String fileName;
  final List<int> fileData;

  const FileContentScreen(
      {super.key, required this.fileName, required this.fileData});

  bool get isSupportedPlatform =>
      Platform.isAndroid || Platform.isIOS || Platform.isWindows;

  @override
  Widget build(BuildContext context) {
    bool isImage = fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png') ||
        fileName.toLowerCase().endsWith('.gif');

    bool isText = fileName.toLowerCase().endsWith('.txt');
    bool isPdf = fileName.toLowerCase().endsWith('.pdf');

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Center(
        child: isImage
            ? Image.memory(Uint8List.fromList(fileData))
            : isText
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        utf8.decode(fileData),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                : isPdf && isSupportedPlatform
                    ? PdfViewPinch(
                        controller: PdfControllerPinch(
                          document: PdfDocument.openData(
                              fileData as FutureOr<Uint8List>),
                        ),
                      )
                    : Text(
                        isPdf
                            ? 'Visualização de PDF não suportada neste dispositivo'
                            : 'Formato de arquivo não suportado',
                        style: const TextStyle(color: Colors.white),
                      ),
      ),
    );
  }
}
