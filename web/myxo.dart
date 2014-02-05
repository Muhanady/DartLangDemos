import 'dart:html';
import 'dart:math' show Random;
import 'dart:convert' show JSON;
import 'dart:async' show Future;



final Random indexGen = new Random();
var columns = ['A','B','C'];
var rows = [1,2,3];
List<Element> boardCellIist = [];
TableElement mTable;
Element element;
SelectElement dropdown;
final aMap= new Map<String,List<int>>();
void main() {
  mTable= querySelector("#main_table")
      ..onClick.listen(getClickedCell)
      ..onMouseOver.listen(mouseOverCell);
  dropdown = querySelector('#dropdown');
  fillBoard();
  WinPossibilities.readPossibilitiesFromJson().then((_){}).catchError((error){ print('error in parssing Json');});
}
void fillBoard()
{
  for(var i in columns)
  {
    for(var j in rows)
    {
      var c = querySelector('#'+i+'_'+j.toString());
      boardCellIist.add(c);
    }
  }
}
void getClickedCell(MouseEvent e)
{
  dropdown.disabled=true;
  element = e.target as Element;
  if(element.tagName=='TD' && element.text=='')
  {
        element.text = dropdown.value;
        boardCellIist.remove(element);
        if(boardCellIist.length >7)
        {

          if(querySelector('#B_2').text!='')
          {
            var myCell = boardCellIist[indexGen.nextInt(boardCellIist.length)];
            myCell.text=dropdown.value.toString() == 'X' ? 'O' : 'X';
            boardCellIist.remove(myCell);
          }
          else
          {
            querySelector('#B_2').text = dropdown.value.toString() == 'X' ? 'O' : 'X';
            boardCellIist.remove(querySelector('#B_2'));
          }
          return;
        }
        checkAndPlay();
  }
}
void checkAndPlay()
{

  var stopLoop = false;
  var playToWin = false;
  var playToDefend = false;
  List<String> emptyCell = [];
  for(var winP in WinPossibilities.possibilitiesList)
  {
    var myCounter = 0;
    var opCounter = 0;
    var mainCounter = 0;
    if(!stopLoop)
    {
      for(var item in winP)
      {
        var cell = querySelector('#'+item);
        if(cell.text == dropdown.value)
        {
          opCounter++;
          mainCounter++;
          boardCellIist.remove(cell);
        }
        else if (cell.text != dropdown.value && cell.text != '')
        {
            myCounter++;
            mainCounter++;
            boardCellIist.remove(cell);
        }
      }
        // set MyXO
      if (myCounter == 2 && opCounter == 0)
      {
        playToWin = true;
        emptyCell.add(winP);
        myCounter++;
      }
      else if (opCounter == 2 && myCounter == 0)
      {
        playToDefend = true;
        emptyCell.add(winP);
        myCounter++;
      }
      if(opCounter == 3)
      {
         window.alert('You WIN!');
         window.location.reload();
         stopLoop = true;
         return;
      }
    }
    else
      continue;
  }
  if(playToDefend || playToWin)
  {
    var stopLoop= false;
    if (playToDefend)
    {
      for(var cellList  in emptyCell)
      {
        if(!stopLoop)
        {
        var count=0;
        var cellToUse;
        for(var cell in cellList)
        {
          if(querySelector('#'+cell).text == dropdown.value && querySelector('#'+cell).text != '')
          {
            count++;
          }
          if(querySelector('#'+cell).text != dropdown.value && querySelector('#'+cell).text == '')
          {
            cellToUse = querySelector('#'+cell);
            count++;
          }
          if(count==3)
          {
            if(playToWin)
            {
              continue;
            }
            cellToUse.text = dropdown.value.toString() == 'X' ? 'O' : 'X';
            boardCellIist.remove(cellToUse);

            stopLoop=true;
            continue;
          }
        }
       }
      }
    }
    if(playToWin)
    {
      for(var cellList in emptyCell)
      {
        if(!stopLoop)
        {
          var count = 0;
          var cellToUse;
          for(var cell in cellList)
          {
            if(querySelector('#'+cell).text != dropdown.value && querySelector('#'+cell).text != '')
            {
              count++;
            }
            if(querySelector('#'+cell).text != dropdown.value && querySelector('#'+cell).text == '')
            {
              cellToUse = querySelector('#'+cell);
              count++;
            }
            if(count == 3)
            {
              cellToUse.text = dropdown.value.toString() == 'X' ? 'O' : 'X';
              boardCellIist.remove(cellToUse);
              window.alert('MYXO WIN!');
              window.location.reload();
              stopLoop = true;
              continue;
            }
           }
        }
        else continue;
      }
    }
   }
  else
  {
   // check if OP when
    if(boardCellIist.length>0)
    {

        var myCell = boardCellIist[indexGen.nextInt(boardCellIist.length)];
        myCell.text=dropdown.value.toString() == 'X' ? 'O' : 'X';
        boardCellIist.remove(myCell);

    }
    else
    {
        window.alert('Game with draw :)');
        window.location.reload();
    }
  }
}

void mouseOverCell(MouseEvent e)
{
    element = e.target as Element;
    if(element.tagName=='TD')
    {
      element.style.backgroundColor='LightGreen';
      element.onMouseOut.listen(mouseOutOfCell);
    }
}
void mouseOutOfCell(MouseEvent e)
{
  element.style.backgroundColor = '';
}


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
//{"A_1","B_1","C_1"},{"A_2","B_2","C_2"},{"A_3","B_3","C_3"},{"A_1","A_2","A_3"},{"B_1","B_2","B_3"},{"C_1","C_2","C_3"},{"A_1","B_2","C_3"},{"C_1","B_2","A_3"}]}
