import 'package:firebase_1/Upload%20File%20to%20Firebase/pdf_viewer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_methods.dart';

class PdfHome extends StatefulWidget {
  const PdfHome({super.key});

  @override
  State<PdfHome> createState() => _PdfHomeState();
}

class _PdfHomeState extends State<PdfHome> {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  void initState() {
    super.initState();
    fetchPdfData();
    setState(() {});
  }

  void fetchPdfData() async {
    _firebaseMethods.getPdf();
    setState(() {}); // Call setState after data is fetched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pdf'),
      ),
      body: _firebaseMethods.pdfData.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemCount: _firebaseMethods.pdfData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          pdfUrl: _firebaseMethods.pdfData[index]['url'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(_firebaseMethods.pdfData[index]['name']),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          : const Center(child: Text('No Data Found')),
      // Show loading spinner while fetching data
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _firebaseMethods.pickFile();
          fetchPdfData(); // Re-fetch data after uploading
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
