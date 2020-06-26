import 'package:yegayega/api/models/Area.dart';

class GetAreasResponse {
  final List<Area> data;

  GetAreasResponse({this.data});

  factory GetAreasResponse.fromJson(List<dynamic> jsonAreas) {
    List<Area> areas = new List();

    if (jsonAreas != null) {
      jsonAreas.forEach((area) => {
      areas.add(Area(
        id: area['zonaid'],
        name: area['nombre'],
        price: double.parse(area['precioenvio']),
      ))
      });
    }

    return GetAreasResponse(
        data: areas);
  }
}