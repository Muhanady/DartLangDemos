library WinPossibilities;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'dart:html';

class WinPossibilities{
  static  List<List<String>>  possibilitiesList = [];
  static Future readPossibilitiesFromJson()
  {
    return HttpRequest.getString('possibilities.json').then(_parsePossibilities);
  }
  static _parsePossibilities(String sJson)
  {
    var possibilities = JSON.decode(sJson);
    possibilitiesList = possibilities['p'];
  }
}