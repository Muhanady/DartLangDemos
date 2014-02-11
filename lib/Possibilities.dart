library WinPossibilities;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'dart:html';

class WinPossibilities{
  static  List<List<String>>  possibilitiesList;
  static int winCellCount;
  static Future readPossibilitiesFromJson()
  {
    return HttpRequest.getString('possibilities.json').then(_parsePossibilities);
  }
  static _parsePossibilities(String sJson)
  {
    var possibilities = JSON.decode(sJson);
    possibilitiesList = possibilities['p'];
  }
  static processFullPossibilities(int size)
  {
    winCellCount = size;
    var listToAdd = new List<List<String>>();
    var count = 0;
    var listCrossL = new List<String>();
    var listCrossR = new List<String>();
   // left to right cross
    for(var listItem in possibilitiesList)
    {
      if(!listCrossL.contains(listItem[count]))
         listCrossL.add(listItem[count]);
      count++;
      if(!listCrossR.contains(listItem[size-count]))
         listCrossR.add(listItem[size-count]);
      continue;
    }

    listToAdd.add(listCrossL);
    listToAdd.add(listCrossR);

    for(var i = 0 ; i< size; i++)
    {
      var list = new List<String>();
      for(var listItem in possibilitiesList)
      {
        list.add(listItem[i]);
      }
      listToAdd.add(list);
    }
    possibilitiesList.addAll(listToAdd);

  }
}