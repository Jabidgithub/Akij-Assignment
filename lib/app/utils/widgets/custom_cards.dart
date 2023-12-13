import 'package:akij_project/app/modules/google_map/geo_punch_list/model/geo_punch_model.dart';
import 'package:flutter/material.dart';

class GeoPunchCard extends StatelessWidget {
  final GeoPunch geoPunch;

  const GeoPunchCard({
    Key? key,
    required this.geoPunch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User ID: ${geoPunch.userId}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Latitude: ${geoPunch.latitude}"),
              Text("Longitude: ${geoPunch.longitude}"),
              SizedBox(height: 8),
              Text("Created At: ${geoPunch.createdAt}"),
              if (geoPunch.updatedAt != null)
                Text("Updated At: ${geoPunch.updatedAt!}"),
            ],
          ),
        ),
      ),
    );
  }
}
