import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pdf_maker_app/controllers/state_controller.dart';
import 'package:pdf_maker_app/screens/pdf_view_page.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/pdf_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PdfController _pdfController = Get.put(PdfController());
  final stateController = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDFMaker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _pdfController.listPdfFiles(),
            icon: Icon(Icons.refresh_rounded, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          stateController.newPdfCreation();
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add_a_photo_outlined, size: 28),
      ),
      body: Obx(() {
        if (_pdfController.pdfFiles.isEmpty) {
          return const Center(
            child: Text(
              "No PDF files available. Create one to get started!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: _pdfController.pdfFiles.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => PDFScreen(
                          path: _pdfController.pdfFiles[index].path,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svgs/pdf.svg",
                          height: Get.height * 0.12,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _pdfController.pdfFiles[index].path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert_rounded),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text('Delete'),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text('Share'),
                                ),
                                const PopupMenuItem(
                                  value: 3,
                                  child: Text('Save to Downloads'),
                                ),
                              ],
                              onSelected: (value) async {
                                if (value == 1) {
                                  final file =
                                      File(_pdfController.pdfFiles[index].path);
                                  await file.delete().then(
                                      (_) => _pdfController.listPdfFiles());
                                } else if (value == 2) {
                                  await Share.shareXFiles([
                                    XFile(_pdfController.pdfFiles[index].path)
                                  ]);
                                } else if (value == 3) {
                                  stateController.saveToDownload(
                                      _pdfController.pdfFiles[index].path);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
    );
  }
}
