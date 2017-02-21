unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, Menus, ComCtrls, XPMan;

type Desk=array [0..8,0..8] of integer;

type
  TForm1 = class(TForm)
    Area: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    StatusBar1: TStatusBar;
    N3: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N2: TMenuItem;
    procedure Init(m,w,r:boolean);              //Èíèöèàëèçàöèÿ, çàïîëíÿåì ìàññèâû íóëÿìè
    procedure CreateSpheres(x,y,c:integer);     //Ñîçäàåì øàðèê ñ êîîðäèíàòàìè x,y è öâåòîì c
    procedure NewSpheres(quantity:integer);     //Ñîçäåì øàðèêè ñ ñëó÷àéíûìè ïîçèöèÿìè
    procedure ClickSpheres(Sender: TObject);    //Ùåë÷îê íà øàðèêå
    procedure Wave(x1,y1,x2,y2:integer);        //Ðàñïðîñòðàíåíèå âîëíû
    procedure Way(x1,y1,x2,y2:integer);         //Íàõîæäåíèå ïóòè îò (x1, y1) äî (x2, y2)
    procedure Move(x1,y1,x2,y2:integer);        //Äâèæåíèå øàðèêà ïî íàéäåííîìó ïóòè
    procedure Pause(milliseconds:integer);      //Ïðîñòî õðåíü
    procedure DestroySpheres(x,y,k,i,j:integer);//Óäàëåíèå k øàðèêîâ, ãäå i, j âñïîìîãàòåëüíûå êîîðäèíàòû äëÿ íàïðàâëåíèÿ
    procedure Data(sc,nl:integer);              //Î÷êè
    procedure DestroyLines;                     //Ïîèñê ëèíèé
    procedure Restart;                          //Íîâàÿ èãðà
    function EmptyPos(Pole:Desk):integer;       //Êîëè÷åñòâî ïóñòûõ ïîçèöèé (äëÿ ïðîâåðêè ïðîèãðûøà)
    function ExitMap(x,y:integer):boolean;      //Âûõîä çà ãðàíèöû ïîëÿ
    function FindLine(x,y,i,j:integer):integer; //Ïîèñê ëèíèè ñ êîîðäèíàò x,y
    function FindSphere(x,y:integer):TImage;    //Ïîèñê Image'a ñ êîîðäèíàòàìè x,y
    procedure FormCreate(Sender: TObject);
    procedure AreaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Road,WaveMap,Map:Desk;
  clisp:boolean;
  xsp,ysp:integer;
  numlines,score:integer;
  RoadFlag,DestroyFlag:boolean;
  FText:TextFile;
  StringArray:Array of Array of Variant;
implementation

{$R *.dfm}

procedure TForm1.Init(m,w,r:boolean);
var
x,y:integer;
begin
for y:=0 to 8 do begin
 for x:=0 to 8 do begin
 if m=true then Map[x,y]:=0;
 if w=true then WaveMap[x,y]:=0;
 if r=true then Road[x,y]:=0;
 end;
end;
end;

procedure TForm1.CreateSpheres(x,y,c:integer);
begin
with TImage.Create(self) do begin
Autosize:=true; TransParent:=true;
Left:=x; Top:=y;
Picture.LoadFromFile('Bitmaps\'+inttostr(c)+'.bmp');
parent:=form1;
Onclick:=ClickSpheres;
end;
end;

procedure TForm1.ClickSpheres(Sender: TObject);
var
str:string;
begin
clisp:=true;
xsp:=(sender as TImage).Left div 30;
ysp:=(sender as TImage).top div 30;
//showmessage(str);
//(sender as TImage).Picture.LoadFromFile('BitmapsSelect\'+inttostr(1)+'.bmp'); */
end;

procedure TForm1.NewSpheres(quantity:integer);
var
i,c,x,y:integer;
nameUser:string;
label Return;
begin
Randomize;
if EmptyPos(Map)>3 then begin
for i:=1 to Quantity do begin
Return:
x:=random(9);
y:=random(9);
c:=random(7)+1;
if Map[x,y]=0 then begin
Map[x,y]:=c;
CreateSpheres(x*30,y*30,c);
end else goto Return;
end;
end else begin
showmessage('Âû ïðîèãðàëè.');
nameUser:=inputBox('Ðåêîðäû','Ââåäèòå ñâîå èìÿ','');
AssignFile(FText,'Ðåêîðäû.txt');
Append(FText);
WriteLn(FText,nameUser,'.',score);
CloseFile(FText);
Restart;
NewSpheres(3);
end;
end;

function TForm1.ExitMap(x,y:integer):boolean;
begin
ExitMap:=false;
if (x>=0) and (x<=8) and (y>=0) and (y<=8) then ExitMap:=true;
end;

procedure TForm1.Wave(x1,y1,x2,y2:integer);
var
x,y,k:integer;
flag:boolean;
begin
flag:=true;
for y:=0 to 8 do begin
  for x:=0 to 8 do begin
  if Map[x,y]>0 then WaveMap[x,y]:=-1 else WaveMap[x,y]:=0;
  end;
end;
k:=1; WaveMap[x1,y1]:=k;
while flag do begin
flag:=false;
 for y:=0 to 8 do begin
  for x:=0 to 8 do begin
   if WaveMap[x,y]=k then begin
    if (WaveMap[x-1,y]=0) and (Exitmap(x-1,y)=true) then begin
    WaveMap[x-1,y]:=k+1;
    flag:=true;
    end;
    if (WaveMap[x+1,y]=0)  and (Exitmap(x+1,y)=true)  then begin
    WaveMap[x+1,y]:=k+1;
    flag:=true;
    end;
    if (WaveMap[x,y-1]=0)  and (Exitmap(x,y-1)=true)  then begin
    WaveMap[x,y-1]:=k+1;
    flag:=true;
    end;
    if (WaveMap[x,y+1]=0)  and (Exitmap(x,y+1)=true)   then begin
    WaveMap[x,y+1]:=k+1;
    flag:=true;
    end;
   end;
  end;
 end;
if WaveMap[x2,y2]>0 then flag:=false else k:=k+1;
end;
end;

procedure TForm1.Way(x1,y1,x2,y2:integer);
var
k:integer;
begin
k:=WaveMap[x2,y2];
Road[x2,y2]:=k-WaveMap[x1,y1]+1;
if (ExitMap(x2-1,y2)=true) and (WaveMap[x2-1,y2]=k-1) then Way(x1,y1,x2-1,y2) else
if (ExitMap(x2+1,y2)=true) and (WaveMap[x2+1,y2]=k-1) then Way(x1,y1,x2+1,y2) else
if (ExitMap(x2,y2-1)=true) and (WaveMap[x2,y2-1]=k-1) then Way(x1,y1,x2,y2-1) else
if (ExitMap(x2,y2+1)=true) and (WaveMap[x2,y2+1]=k-1) then Way(x1,y1,x2,y2+1);
end;

function TForm1.FindSphere(x,y:integer):TImage;
var
i:integer;
begin
for i:=0 to ComponentCount-1 do begin
if (Components[i] is TImage) and (Timage(Components[i]).Name<>'Area') and (Timage(Components[i]).Left=x) and (Timage(Components[i]).top=y) then begin
Result:=Timage(Components[i]);
exit;
end;
end;
end;

procedure TForm1.Move(x1,y1,x2,y2:integer);
var
Image:Timage;
x,y,i:integer;
begin
RoadFlag:=false;
init(false,true,true);
Image:=FindSphere(x1*30,y1*30);
Wave(x1,y1,x2,y2);
if WaveMap[x2,y2]>0 then begin
RoadFlag:=true;
Way(x1,y1,x2,y2);
x:=x1;
y:=y1;
repeat
Pause(50);
 if Road[x-1,y]-Road[x,y]=1 then begin
 x:=x-1;
 end else
 if Road[x+1,y]-Road[x,y]=1 then begin
 x:=x+1;
 end else
 if Road[x,y-1]-Road[x,y]=1 then begin
 y:=y-1;
 end else
 if Road[x,y+1]-Road[x,y]=1 then begin
 y:=y+1;
 end;
Image.Left:=x*30;
Image.Top:=y*30;
until (x=x2) and (y=y2);
Map[x2,y2]:=Map[x1,y1];
Map[x1,y1]:=0;
end;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin
score:=0;
numlines:=0;
Init(true,true,true);
NewSpheres(3);
end;

procedure TForm1.Pause(milliseconds:integer);
begin
application.ProcessMessages;
sleep(milliseconds);
end;

procedure TForm1.DestroySpheres(x,y,k,i,j:integer);
var
n,dx,dy:integer;
image:TImage;
begin
n:=0; dx:=x; dy:=y;
while n<>k do begin
image:=FindSphere(dx*30,dy*30); image.Destroy;
application.ProcessMessages;
Map[dx,dy]:=0;
n:=n+1; dx:=dx+i; dy:=dy+j;
end;
Data(k,1);
DestroyFlag:=true;
end;

function TForm1.FindLine(x,y,i,j:integer):integer;
var
dx,dy,k:integer;
begin
dx:=x; dy:=y; k:=0;
while Map[x,y]=Map[dx,dy] do begin
 if ExitMap(dx,dy)=true then begin
 dx:=dx+i;
 dy:=dy+j;
 k:=k+1;
 end else break;
end;
result:=k;
end;

procedure TForm1.DestroyLines;
var
x,y,k,i,j:integer;
begin
DestroyFlag:=false;
for y:=0 to 8 do begin
 for x:=0 to 8 do begin
  if Map[x,y]<>0 then begin
  if FindLine(x,y,1,0)>4  then DestroySpheres(x,y,FindLine(x,y,1,0),1,0) else
  if FindLine(x,y,1,1)>4  then DestroySpheres(x,y,FindLine(x,y,1,1),1,1)else
  if FindLine(x,y,0,1)>4  then DestroySpheres(x,y,FindLine(x,y,0,1),0,1) else
  if FindLine(x,y,-1,1)>4 then DestroySpheres(x,y,FindLine(x,y,-1,1),-1,1);
  end;
 end;
end;
end;

function TForm1.EmptyPos(Pole:Desk):integer;
var
x,y,e:integer;
begin
e:=0;
for y:=0 to 8 do begin
 for x:=0 to 8 do begin
 if Pole[x,y]=0 then e:=e+1;
 end;
end;
result:=e;
end;

procedure TForm1.Data(sc,nl:integer);
begin
numlines:=numlines+nl;
if(sc=5) then
  score:=score+sc
  else
    score:=score+(5+(sc-5)*5);
Statusbar1.Panels[0].Text:='Óíè÷òîæåíî ëèíèé: '+inttostr(numlines);
Statusbar1.Panels[1].Text:='Î÷êè: '+inttostr(score);
end;

procedure TForm1.AreaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if clisp=true then begin
clisp:=false;
Move(xsp,ysp,x div 30,y div 30);
if RoadFlag=true then begin
Pause(100);
DestroyLines;
Pause(150);
if DestroyFlag=false then begin
NewSpheres(3);
DestroyLines;
end;
end;
RoadFlag:=false;
end;

end;
procedure TForm1.N6Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.Restart;
var
i:integer;
label Return;
begin
init(true,true,true);
score:=0;
numlines:=0;
Return:
for i:=0 to ComponentCount-1 do begin
if (Components[i] is TImage) and (Timage(Components[i]).Name<>'Area') then begin
Timage(Components[i]).Destroy;
goto Return;
end;
end;
Statusbar1.Panels[0].Text:='Óíè÷òîæåíî ëèíèé: 0';
Statusbar1.Panels[1].Text:='Î÷êè: 0';
end;


procedure TForm1.N2Click(Sender: TObject);
var
ic,i,j, pmax, tmp:integer;
tmpstr:string;
stroka:string;
records:string;
sl:TStringList;
begin
records:='';
sl:=TStringList.Create;
AssignFile(FText,'Ðåêîðäû.txt');
Reset(FText);
ic:=0;
while not EOF(FText) do
begin
  SetLength(StringArray,Length(StringArray)+1,3);
  ReadLn(FText,stroka);
  sl.Delimiter:='.';
  sl.DelimitedText:=stroka;

  StringArray[ic][0]:=sl[0];
  StringArray[ic][1]:=sl[1];
  inc(ic);
end;
for i := 0 to ic-1 do
    begin
      pmax := i;
      for j := i+1 to ic-1  do
        if StringArray[j][1] >  StringArray[pmax][1] then
          pmax := j;
      tmp := StringArray[i][1];
      tmpstr:= StringArray[i][0];
      StringArray[i][1] := StringArray[pmax][1];
      StringArray[i][0] := StringArray[pmax][0];
      StringArray[pmax][1] := tmp;
      StringArray[pmax][0] := tmpstr;
    end;
for I := 0 to ic-1 do
begin
 records:=records+string(StringArray[i][0])+' '+string(StringArray[i][1]);
  if(i<>ic-1) then
    records:=records+#13#10;
end;
showmessage(records);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
Restart;
NewSpheres(3);
end;


end.
// 228 322 я тут был азазазаз
