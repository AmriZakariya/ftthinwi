import 'package:flutter/material.dart';
import 'package:telcabo/Tools.dart';
import 'package:telcabo/ui/InterventionHeaderInfoWidget.dart';

class DetailIntervention extends StatefulWidget {
  @override
  State<DetailIntervention> createState() => _DetailInterventionState();
}

class _DetailInterventionState extends State<DetailIntervention> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: <Widget>[],
      ),
      // endDrawer: EndDrawerWidget(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/bg_home.jpeg"),
                //   fit: BoxFit.cover,
                // ),
                color: Tools.colorBackground),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: InterventionHeaderInfoClientWidget(),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.black,
                  height: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: InterventionHeaderInfoProjectWidget()),
                SizedBox(
                  height: 20,
                ),
                InterventionInformationWidget(),
                SizedBox(
                  height: 20,
                ),
                InterventionHeaderImagesWidget(),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                HeaderCommentaireWidget(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
