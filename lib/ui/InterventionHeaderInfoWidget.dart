import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:telcabo/Tools.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';
class InterventionHeaderInfoClientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demande = Tools.selectedDemande;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Client : ${demande?.consommateur ?? ""}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            ExpandChild(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.black, height: 2),
                    const SizedBox(height: 15),

                    // Téléphone
                    GestureDetector(
                      onTap: () {
                        launch("tel://${demande?.telMobile ?? ""}");
                      },
                      child: InfoItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.phone, size: 18),
                        title: "Téléphone :",
                        description: demande?.telMobile ?? "",
                        iconEnd: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: FaIcon(
                            FontAwesomeIcons.phoneVolume,
                            size: 22,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Adresse
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.houseChimney, size: 18),
                      title: "Adresse :",
                      description: demande?.adresseComplement1 ?? "",
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterventionHeaderInfoProjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demande = Tools.selectedDemande;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.receipt,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Case Id : ${demande?.parent ?? ""}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            ExpandChild(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.black, height: 2),
                    const SizedBox(height: 15),

                    // Type demande
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.tag, size: 18),
                      title: "Type demande :",
                      description: demande?.type ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Equipement
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.box, size: 18),
                      title: "Equipement (SN Routeur) :",
                      description: demande?.snRouteur ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Situation abonnement (mapped to fournisseur)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.toggleOn, size: 18),
                      title: "Situation abonnement :",
                      description: demande?.fournisseur ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Nom plan tarifaire (mapped to offreId)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.moneyBill, size: 18),
                      title: "Offre (Plan tarifaire) :",
                      description: demande?.offreId ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Verification cablage pto (mapped to pTestSignalViaPm)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.check, size: 18),
                      title: "Test signal (PTO) :",
                      description: demande?.pTestSignalViaPm ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Internet (mapped to pSpeedTest)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.exclamationTriangle, size: 18),
                      title: "Internet (Speed Test) :",
                      description: demande?.pSpeedTest ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Power (mapped to pRouteurAllume)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.powerOff, size: 18),
                      title: "Power (Routeur allumé) :",
                      description: demande?.pRouteurAllume ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // PON (mapped to ftthSn as a reference)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.plug, size: 18),
                      title: "FTTH SN (PON ref) :",
                      description: demande?.ftthSn ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // Cablage redemarrage equipement (mapped to pPassageCableAvant)
                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.cableCar, size: 18),
                      title: "Câblage (Avant) :",
                      description: demande?.pPassageCableAvant ?? "",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterventionInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demande = Tools.selectedDemande;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.info,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                "Informations de l'Intervention",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            ExpandChild(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.black, height: 2),
                    const SizedBox(height: 15),

                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.networkWired, size: 18),
                      title: "Adresse MAC :",
                      description: demande?.adresseMac ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    InfoItemWidget(
                      icon: const FaIcon(FontAwesomeIcons.route, size: 18),
                      title: "SN Routeur :",
                      description: demande?.snRouteur ?? "",
                    ),
                    const SizedBox(height: 20.0),

                    // InfoItemWidget(
                    //   icon: const FaIcon(FontAwesomeIcons.networkWired, size: 18),
                    //   title: "SN GPON :",
                    //   description: demande?.snGpon ?? "",
                    // ),
                    // const SizedBox(height: 20.0),
                    //
                    // InfoItemWidget(
                    //   icon: const FaIcon(FontAwesomeIcons.networkWired, size: 18),
                    //   title: "MAC Ancienne Box :",
                    //   description: demande?.macAnBox ?? "",
                    // ),
                    // const SizedBox(height: 20.0),
                    //
                    // InfoItemWidget(
                    //   icon: const FaIcon(FontAwesomeIcons.route, size: 18),
                    //   title: "SN Ancienne Box :",
                    //   description: demande?.snAnBox ?? "",
                    // ),
                    // const SizedBox(height: 20.0),
                    //
                    // InfoItemWidget(
                    //   icon: const FaIcon(FontAwesomeIcons.networkWired, size: 18),
                    //   title: "SN Ancienne G-PON :",
                    //   description: demande?.snAnGpon ?? "",
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagesModelTest {
  final String? selectedImage;
  final String? selectedImageTxt;

  ImagesModelTest(this.selectedImage, this.selectedImageTxt);
}

class InterventionHeaderImagesWidget extends StatelessWidget {
  ValueNotifier<ImagesModelTest> imageModelValueNotifer =
      ValueNotifier(ImagesModelTest(
    "${Tools.baseUrl}/img/demandes/" + (Tools.selectedDemande?.pPassageCableApres ?? ""),
    "Photo PBI avant l’installation",
  ));

  List<CardItem> items = [
    ImageCarditem(
        image: Image(
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
          child: Container(
            child: Icon(Icons.image_not_supported_outlined),
          ),
        );
      },
      image: CachedNetworkImageProvider("${Tools.baseUrl}/img/demandes/" +
          (Tools.selectedDemande?.pPassageCableApres ?? "")),
    )),
    ImageCarditem(
        image: Image(
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
          child: Container(
            child: Icon(Icons.image_not_supported_outlined),
          ),
        );
      },
      image: CachedNetworkImageProvider("${Tools.baseUrl}/img/demandes/" +
          (Tools.selectedDemande?.pPassageCableApres ?? "")),
    )),
    ImageCarditem(
        image: Image(
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
          child: Container(
            child: Icon(Icons.image_not_supported_outlined),
          ),
        );
      },
      image: CachedNetworkImageProvider("${Tools.baseUrl}/img/demandes/" +
          (Tools.selectedDemande?.pPassageCableApres ?? "")),
    )),
    ImageCarditem(
        image: Image(
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
          child: Container(
            child: Icon(Icons.image_not_supported_outlined),
          ),
        );
      },
      image: CachedNetworkImageProvider("${Tools.baseUrl}/img/demandes/" +
          (Tools.selectedDemande?.pPassageCableApres ?? "")),
    )),
    ImageCarditem(
        image: Image(
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
          child: Container(
            child: Icon(Icons.image_not_supported_outlined),
          ),
        );
      },
      image: CachedNetworkImageProvider("${Tools.baseUrl}/img/demandes/" +
          (Tools.selectedDemande?.pPassageCableApres ?? "")),
    )),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(
              20) // use instead of BorderRadius.all(Radius.circular(20))
          ),
      child: Center(
          child: Column(
        children: [
          Column(children: [
            SizedBox(
              height: 15.0,
            ),
            // CircleAvatar(
            //   radius: 32.0,
            //   backgroundImage: AssetImage('assets/user.png'),
            //   backgroundColor: Colors.white,
            // ),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                // primary: Tools.colorPrimary,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.image_sharp,
                size: 40,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Text('Photos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
          ]),
          ExpandChild(
              child: ValueListenableBuilder(
            valueListenable: imageModelValueNotifer,
            builder: (BuildContext context, ImagesModelTest imageModelTest,
                Widget? child) {
              return Column(
                children: [
                  Text(
                    imageModelTest.selectedImageTxt ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Open Sans',
                        letterSpacing: 1.3,
                        fontSize: 16),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                    height: 200.0,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return FullScreenImageWidget(
                                title: imageModelTest.selectedImageTxt ?? "",
                                imagePath: imageModelTest.selectedImage ?? "",
                              );
                            }));
                          },
                          child: ClipRect(
                            // child: PhotoView(
                            //   imageProvider: CachedNetworkImageProvider(
                            //       imageModelTest.selectedImage ?? ""),
                            //   maxScale: PhotoViewComputedScale.covered * 2.0,
                            //   minScale: PhotoViewComputedScale.contained * 0.8,
                            //   initialScale: PhotoViewComputedScale.covered,
                            // ),
                            child: Image(
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Center(
                                  child: Container(
                                    child: Icon(
                                        Icons.image_not_supported_outlined),
                                  ),
                                );
                              },
                              image: CachedNetworkImageProvider(
                                  imageModelTest.selectedImage ?? ""),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return FullScreenImageWidget(
                                  title: imageModelTest.selectedImageTxt ?? "",
                                  imagePath: imageModelTest.selectedImage ?? "",
                                );
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // color: Colors.black12,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),

                              // width: 30,
                              // height: 30,
                              // padding: const EdgeInsets.all(12.0),
                              // child: const CircularProgressIndicator(),
                              child: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: HorizontalCardPager(
                    onPageChanged: (page) {
                      print("page : $page");

                      if (page == 0) {
                        imageModelValueNotifer.value = ImagesModelTest(
                            "${Tools.baseUrl}/img/demandes/" +
                                (Tools.selectedDemande?.pPassageCableApres ?? ""),
                            "Photo problème");
                      } else if (page == 1) {
                        imageModelValueNotifer.value = ImagesModelTest(
                            "${Tools.baseUrl}/img/demandes/" +
                                (Tools.selectedDemande?.pPassageCableApres ?? ""),
                            "Photo signal");
                      }
                      if (page == 2) {
                        imageModelValueNotifer.value = ImagesModelTest(
                            "${Tools.baseUrl}/img/demandes/" +
                                (Tools.selectedDemande?.pPassageCableApres ?? ""),
                            "Photo de resolution de probleme");
                      }
                      if (page == 3) {
                        imageModelValueNotifer.value = ImagesModelTest(
                            "${Tools.baseUrl}/img/demandes/" +
                                (Tools.selectedDemande?.pPassageCableApres ?? ""),
                            "Photo supplémentaire 1");
                      }
                      if (page == 4) {
                        imageModelValueNotifer.value = ImagesModelTest(
                            "${Tools.baseUrl}/img/demandes/" +
                                (Tools.selectedDemande?.pPassageCableApres ?? ""),
                            "Photo supplémentaire 2");
                      }
                    },
                    onSelectedItem: (page) {
                      print("onSelectedItem : $page");
                    },
                    items: items,
                    initialPage: 0,
                  )),

                ],
              );
            },
          )),
        ],
      )),
    );
  }
}
class InfoItemWidget extends StatelessWidget {
  const InfoItemWidget({
    Key? key,
    this.iconData,
    required this.title,
    required this.description,
    this.icon,
    this.iconEnd,
  }) : super(key: key);

  final IconData? iconData;
  final String title;
  final String description;
  final Widget? icon;
  final Widget? iconEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              if (icon != null || iconData != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: icon ?? Icon(iconData),
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Tools.colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (iconEnd != null)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: iconEnd,
          ),
      ],
    );
  }
}


// class MapSample extends StatelessWidget {
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//
//   getCurrentLatitudeLongitude() {
//     double lat;
//     try {
//       lat = double.parse(Tools.selectedDemande?.latitude ?? " 33.589886");
//     } catch (e) {
//       print(e);
//       lat = 33.589886;
//     }
//
//     double long;
//     try {
//       long = double.parse(Tools.selectedDemande?.longitude ?? " -7.603869");
//     } catch (e) {
//       print(e);
//       long = -7.603869;
//     }
//
//     return LatLng(lat, long);
//   }
//
//   getCurrentLatitude() {
//     double lat;
//     try {
//       lat = double.parse(Tools.selectedDemande?.latitude ?? " 33.589886");
//     } catch (e) {
//       print(e);
//       lat = 33.589886;
//     }
//
//     return lat;
//   }
//
//   getCurrentLongitude() {
//     double long;
//     try {
//       long = double.parse(Tools.selectedDemande?.longitude ?? " -7.603869");
//     } catch (e) {
//       print(e);
//       long = -7.603869;
//     }
//
//     return long;
//   }
//
//   Future<void> _launchUrl(bool isDir, double lat, double lon) async {
//     String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
//
//     if (isDir) {
//       url =
//           'https://www.google.com/maps/dir/?api=1&origin=Googleplex&destination=$lat,$lon';
//     }
//
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Widget mapToolBar() {
//     return Row(
//       children: [
//         FloatingActionButton(
//           child: Icon(Icons.map),
//           backgroundColor: Colors.blue,
//           onPressed: () {
//             _launchUrl(false, getCurrentLatitude(), getCurrentLatitude());
//           },
//         ),
//         FloatingActionButton(
//           child: Icon(Icons.directions),
//           backgroundColor: Colors.blue,
//           onPressed: () {
//             _launchUrl(true, getCurrentLatitude(), getCurrentLatitude());
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String markerIdVal = Tools.selectedDemande?.client ?? "";
//     final MarkerId markerId = MarkerId(markerIdVal);
//
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: getCurrentLatitudeLongitude(),
//       infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
//       onTap: () {
// //                  _onMarkerTapped(markerId);
//       },
//       onDragEnd: (LatLng position) {
// //                  _onMarkerDragEnd(markerId, position);
//       },
//     );
//     markers[markerId] = marker;
//
//     return Container(
//       margin: const EdgeInsets.only(left: 20.0, right: 20.0),
//       decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.black,
//           ),
//           borderRadius: BorderRadius.circular(
//               20) // use instead of BorderRadius.all(Radius.circular(20))
//           ),
//       child: Center(
//           child: Column(
//         children: [
//           Column(children: [
//             SizedBox(
//               height: 15.0,
//             ),
//             // CircleAvatar(
//             //   radius: 32.0,
//             //   backgroundImage: AssetImage('assets/user.png'),
//             //   backgroundColor: Colors.white,
//             // ),
//             ElevatedButton(
//               onPressed: () async {},
//               style: ElevatedButton.styleFrom(
//                 // primary: Tools.colorPrimary,
//                 shape: CircleBorder(),
//                 padding: EdgeInsets.all(10),
//               ),
//               child: const Icon(
//                 Icons.gps_fixed,
//                 size: 40,
//               ),
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Center(
//               child: Text("Geolocalisation",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16.0,
//                   )),
//             ),
//           ]),
//           ExpandChild(
//             child: Column(
//               children: [
//                 Divider(
//                   color: Colors.black,
//                   height: 2,
//                 ),
//                 // SizedBox(
//                 //   height: 15,
//                 // ),
//                 Container(
//                     // color: Colors.white,
//                     height: 300,
//                     child: GoogleMap(
//                       gestureRecognizers: Set()
//                         ..add(Factory<PanGestureRecognizer>(
//                             () => PanGestureRecognizer())),
//                       mapType: MapType.terrain,
//                       initialCameraPosition: CameraPosition(
//                         target: getCurrentLatitudeLongitude(),
//                         zoom: 14.4746,
//                       ),
//                       // onMapCreated: (GoogleMapController controller) {
//                       //   _controller.complete(controller);
//                       // },
//                       myLocationButtonEnabled: false,
//                       markers: Set<Marker>.of(markers.values),
//                     )),
//               ],
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }

class HeaderCommentaireWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(
              20) // use instead of BorderRadius.all(Radius.circular(20))
          ),
      child: Center(
          child: Column(
        children: [
          Column(children: [
            SizedBox(
              height: 15.0,
            ),
            // CircleAvatar(
            //   radius: 32.0,
            //   backgroundImage: AssetImage('assets/user.png'),
            //   backgroundColor: Colors.white,
            // ),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                // primary: Tools.colorPrimary,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.comment,
                size: 40,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Text("Commentaires",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
          ]),
          ExpandChild(
            child: Column(
              children: [
                Divider(
                  color: Colors.black,
                  height: 2,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Timeline.tileBuilder(
                    shrinkWrap: true,
                    builder: TimelineTileBuilder.fromStyle(
                      contentsBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Tools.selectedDemande
                                  ?.commentaires?[index].commentaire ??
                              ""),
                        ),
                      ),
                      oppositeContentsBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Column(
                              children: [
                                // Text(Tools.selectedDemande?.commentaires?[index].userId ?? ""),
                                Text(Tools.selectedDemande?.commentaires?[index]
                                        .created
                                        ?.trim() ??
                                    ""),
                              ],
                            )),
                      ),
                      contentsAlign: ContentsAlign.alternating,
                      indicatorStyle: IndicatorStyle.outlined,
                      connectorStyle: ConnectorStyle.dashedLine,
                      itemCount:
                          Tools.selectedDemande?.commentaires?.length ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class FullScreenImageWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  const FullScreenImageWidget(
      {Key? key, required this.title, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imagePath),
      ),
      // Image.network(
      // imagePath,
      // fit: BoxFit.cover,
      // height: double.infinity,
      // width: double.infinity,
      // alignment: Alignment.center,
      // ),
    );
  }
}
