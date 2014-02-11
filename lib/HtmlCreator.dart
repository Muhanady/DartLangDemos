library HtmlCreator;
//import 'dart:html';
import "Possibilities.dart";



class HtmlCreator
{
  var _letters=['A','B','C','D'];
  String _innerHtml='<tbody>';
  int _countTowin=0;
//  var _possibilities = new List<List<String>>();
  String get innerHtml => _innerHtml;
//  List<List<String>> get possibilities => _possibilities;
  HtmlCreator(int boardSize)
  {
    WinPossibilities.possibilitiesList= new List<List<String>>();
   this._countTowin=boardSize;
   for(var i= 0;i<boardSize;i++)
   {
     var p = [];
     _innerHtml += '<tr>';
     if(_letters[i].isNotEmpty)
     {
       for(var j= 0;j<boardSize;j++)
       {
         _innerHtml += "<td id='"+_letters[j]+"_"+(i+1).toString()+"'></td>";
         p.add(_letters[j]+"_"+(i+1).toString());
       }
     }
     WinPossibilities.possibilitiesList.add(p);
     _innerHtml += '</tr>';
   }
   _innerHtml+="</tbody>";

   WinPossibilities.processFullPossibilities(boardSize);
  }
}