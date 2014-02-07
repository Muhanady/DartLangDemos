import 'dart:html';
import 'dart:math' show Random;

import 'dart:async' show Future;
import '../lib/Possibilities.dart';



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
      ..onClick.listen(getClickedCell);
     // ..onMouseOver.listen(mouseOverCell);
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
            myCell.classes.add('Clicked');
            boardCellIist.remove(myCell);
          }
          else
          {
            querySelector('#B_2').text = dropdown.value.toString() == 'X' ? 'O' : 'X';
            querySelector('#B_2').classes.add('Clicked');
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
        for(var aa in winP)
        {
          querySelector('#'+aa).className='Clicked Success';
        }
        declareTheWinner('You WIN!');
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
            cellToUse.classes.add('Clicked');
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
            querySelector('#'+cell).className='Clicked Success';
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
              cellToUse.classes.add('Clicked');
              boardCellIist.remove(cellToUse);
              declareTheWinner('MYXO WIN!');
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
        myCell.classes.add('Clicked');
        boardCellIist.remove(myCell);
    }
    else
    {
      declareTheWinner('Game with draw :)');
    }
  }
}
void declareTheWinner(String s)
{
  DivElement div =querySelector('#animation')
      ..text = s;
  AnchorElement okLink= new AnchorElement(href: '#1')
    ..text ='Play!'
    ..onClick.listen((e){window.location.reload();});
  div.children.add(okLink);

  AnchorElement a = querySelector('#linkelement');
  a.click();

}




//{"A_1","B_1","C_1"},{"A_2","B_2","C_2"},{"A_3","B_3","C_3"},{"A_1","A_2","A_3"},{"B_1","B_2","B_3"},{"C_1","C_2","C_3"},{"A_1","B_2","C_3"},{"C_1","B_2","A_3"}]}
