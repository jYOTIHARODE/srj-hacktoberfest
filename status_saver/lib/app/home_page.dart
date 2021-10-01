import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/providers/app_data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AppData>(
      builder: (context, appData, child) {
        return Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.1),
          appBar: AppBar(
            title: Text(
              'Recent',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              appData.onPull();
            },
            child: appData.isLoading
                ? LinearProgressIndicator()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: StaggeredGridView.countBuilder(
                      itemCount: appData.imageList.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        File file = new File(appData.imageList[index]);
                        return InkWell(
                          onTap: () async {
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.all(10),
                                  content: Container(
                                    height: size.height * 0.6,
                                    width: size.width * 0.8,
                                    child: PhotoView(
                                      backgroundDecoration: BoxDecoration(),
                                      imageProvider: FileImage(file),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        if (null != file) {
                                          Directory directory = Directory(
                                              '/storage/emulated/0/Pictures/StorySaver');

                                          Map map = Map();
                                          map['path'] = file.path;
                                          map['directory'] = directory;

                                          // await compute(
                                          //     appData.saveImageToDisk, map);
                                          await appData.saveImageToDisk(map);
                                          appData.syncSavedImages();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: appData.isSavingData == true
                                          ? CircularProgressIndicator()
                                          : Text('Save'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (null != file) {
                                          appData.shareImage(file);
                                        }
                                      },
                                      child: Text('Share'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Back'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.fitWidth,
                                )),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.count(1, index.isEven ? 1.3 : 1.6);
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
