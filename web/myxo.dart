import 'dart:html';
import 'dart:math' show Random;

import 'dart:async' show Future;
import '../lib/Possibilities.dart';
import '../lib/HtmlCreator.dart';


final Random indexGen = new Random();
var columns = ['A','B','C','D'];
List<Element> boardCellIist = [];
List<List<String>> toDeleteFrom;
TableElement mTable;
Element element;
SelectElement dropdown = querySelector('#dropdown');
SelectElement ddBoardSize = querySelector("#ddBoardSize");
bool firstMove = true;

final aMap= new Map<String,List<int>>();


void main() {
  mTable= querySelector("#main_table")
      ..onClick.listen(getClickedCell);
     // ..onMouseOver.listen(mouseOverCell);
  ddBoardSize.onChange.listen((e){
        mTable.innerHtml=' ';
        if(ddBoardSize.value!="0")
        mTable.appendHtml(new HtmlCreator(int.parse(ddBoardSize.value)).innerHtml);
        fillBoard();
    });
 // WinPossibilities.readPossibilitiesFromJson().then((_){}).catchError((error){ print('error in parssing Json');});
}
void fillBoard()
{
  dropdown.disabled=false;
  firstMove = true;
  for(var i= 0;i<int.parse(ddBoardSize.value);i++)
  {
    if(columns[i].isNotEmpty)
    {
      for(var j= 0;j<int.parse(ddBoardSize.value);j++)
      {
        var c = window.document.querySelector('#'+columns[j]+"_"+(i+1).toString())
            ..text=''
            ..classes.remove('Clicked')
              ..classes.remove("Success");

        boardCellIist.add(c);
      }
    }
  }
  toDeleteFrom = new List<List<String>>();
  WinPossibilities.possibilitiesList.forEach((f)=>toDeleteFrom.add(f));
}
void getClickedCell(MouseEvent e)
{
  dropdown.disabled=true;
  element = e.target as Element;
  if(element.tagName=='TD' && element.text=='')
  {
        element.text = dropdown.value;
        element.classes.add('Clicked');
        boardCellIist.remove(element);
        var aa = boardCellIist.length;
        var bb = (int.parse(ddBoardSize.value)* int.parse(ddBoardSize.value) -2);
        if(firstMove)
        {
          if(ddBoardSize.value == "3" && querySelector("#B_2").text=="")
          {
            querySelector('#B_2').text = dropdown.value.toString() == 'X' ? 'O' : 'X';
            querySelector('#B_2').classes.add('Clicked');
            boardCellIist.remove(querySelector('#B_2'));
          }
          else
          {
            var myCell = boardCellIist[indexGen.nextInt(boardCellIist.length)];
            myCell.text=dropdown.value.toString() == 'X' ? 'O' : 'X';
            myCell.classes.add('Clicked');
            boardCellIist.remove(myCell);
          }
          firstMove = false;
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
  var bestPositionForOp = new Map<int,List<List<String>>>();
  var bestPositionForMy = new Map<int,List<List<String>>>();
  var emptyLines = new Map<int,List<List<String>>>();
  for(var winP in WinPossibilities.possibilitiesList)
  {
    var myCounter = 0;
    var opCounter = 0;
    var mainCounter = 0;
    var winningList=new List<Element>();
    if(!stopLoop)
    {
      for(var item in winP)
      {
        var oCell = querySelector('#'+item);
        if(oCell.text == dropdown.value)
        {
          oCell.classes.add('Clicked');
          boardCellIist.remove(oCell);
          opCounter++;
          mainCounter++;
        }
        else if (oCell.text != dropdown.value && oCell.text != '')
        {
            myCounter++;
            mainCounter++;
        }
      }
          // set MyXO
      if (myCounter == WinPossibilities.winCellCount - 1 && opCounter == 0)
      {
          myCounter++;
      }
       if(mainCounter == WinPossibilities.winCellCount)
          toDeleteFrom.remove(winP);
    }
    else
      continue;
    if (opCounter >0 && myCounter == 0)
    {
      if(bestPositionForOp[opCounter]== null)
        bestPositionForOp[opCounter]= new List<List<String>>();
      bestPositionForOp[opCounter].add(winP);
    }
    else if(myCounter >0 && opCounter == 0)
    {
      if(bestPositionForMy[myCounter]== null)
        bestPositionForMy[myCounter]= new List<List<String>>();
      bestPositionForMy[myCounter].add(winP);
    }
    else
    {
      if(emptyLines[0]== null)
        emptyLines[0]= new List<List<String>>();
      emptyLines[0].add(winP);
    }
  }
  // Op WIN
  if (getHighestPossibilityKey(bestPositionForOp) == WinPossibilities.winCellCount)
  {
    var winningList=new List<Element>();
    for(var cell in bestPositionForOp[getHighestPossibilityKey(bestPositionForOp)].first)
    {
      winningList.add(querySelector('#'+cell));
    }
    declareTheWinner('You WIN!',winningList);
    return;
  }
// play to defend
  if(getHighestPossibilityKey(bestPositionForOp) == (WinPossibilities.winCellCount -1)
      && toDeleteFrom.any((f)=>bestPositionForOp[getHighestPossibilityKey(bestPositionForOp)].contains(f))
      && getHighestPossibilityKey(bestPositionForMy) != WinPossibilities.winCellCount)
   {
     for(var cell in bestPositionForOp[getHighestPossibilityKey(bestPositionForOp)].first)
      {
        var oCell = querySelector('#'+cell);
        if(oCell.text == '')
        {
          oCell.text = dropdown.value.toString() == 'X' ? 'O' : 'X';
          oCell.classes.add('Clicked');
          boardCellIist.remove(oCell);
          return;
        }
      }
    }
   // Play To win
  else
   {
    var done = false;
      for(var key in bestPositionForMy.keys )
      {
        if(!stopLoop){

        if(bestPositionForMy[key]!= null)
        {
          for(var cell in bestPositionForMy[key].first)
          {
            var oCell = querySelector('#'+cell);
            if(oCell.text == '')
            {
              oCell.text = dropdown.value.toString() == 'X' ? 'O' : 'X';
              oCell.classes.add('Clicked');
              boardCellIist.remove(oCell);
              stopLoop=true;
              done = true;
              break;

            }
         }
      }
     }
    }
    if(!done)
    {
      if(boardCellIist.length>0){
        var oCell = boardCellIist[indexGen.nextInt(boardCellIist.length)];
        oCell.text=dropdown.value.toString() == 'X' ? 'O' : 'X';
        oCell.classes.add('Clicked');
        boardCellIist.remove(oCell);
      }
    }
   }
   if( getHighestPossibilityKey(bestPositionForMy) == WinPossibilities.winCellCount)
       {
         var winningList=new List<Element>();
         for(var cell in bestPositionForMy[getHighestPossibilityKey(bestPositionForMy)].first)
         {
           winningList.add(querySelector('#'+cell));
         }
         declareTheWinner('MYXO WIN!',winningList);
      }
    if(boardCellIist.length==0)
    {declareTheWinner('Game with draw :)',new List<Element>());}
}


void declareTheWinner(String s, List<Element> winnerCells)
{
  querySelector('#animation').style.display = 'block';
  querySelector('#bgCover').classes.add('Cover');
  for(var cell in winnerCells)
  {
    cell.className='Clicked Success';
  }
  DivElement div =querySelector('#animation')
      ..text = s;
  AnchorElement okLink= new AnchorElement(href: '#1')
    ..text ='Play!'
    ..id='okLink'
    ..onClick.listen((e){

  querySelector('#animation').style.display = 'none';
  querySelector('#bgCover').classes.remove('Cover');
  fillBoard();
    });
  div.children.add(okLink);

  AnchorElement a = querySelector('#linkelement');
  a.click();

}

int getHighestPossibilityKey(Map m)
{
  int highest = 0;
  m.forEach((k,v)=>
  k > highest? highest = k : 0
  );
  return highest;
}


//{"A_1","B_1","C_1"},{"A_2","B_2","C_2"},{"A_3","B_3","C_3"},{"A_1","A_2","A_3"},{"B_1","B_2","B_3"},{"C_1","C_2","C_3"},{"A_1","B_2","C_3"},{"C_1","B_2","A_3"}]}
