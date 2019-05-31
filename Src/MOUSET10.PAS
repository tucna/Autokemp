unit mouseT10;

interface

type
  TCursor = record
  	maska: array[0..15] of word;
     vrch: array[0..15] of word;
  end;

function  MouseReset: boolean;
procedure EnableMouseDriver;
function  DisableMouseDriver: boolean;
function  MouseDriverVersion: word;
procedure ShowMouseCursor;
procedure HideMouseCursor;
procedure SetMousePosition(X, Y: word);
procedure SetMouseHorizontalMaxMinPosition(Max, Min: word);
procedure SetMouseVerticalMaxMinPosition(Max, Min: word);
procedure GetMousePosition(var X, Y: word);
procedure GetMousePress(var B1, B2, B3: boolean);
procedure SetMouseTextCursor(StartScreenMask, endScreenMask: word);
procedure SetMouseGraphicsCursor(var NewCursor: TCursor);
function MouseIn(x1,y1,x2,y2:integer):boolean;
procedure sensitive(horiz,vert:word);

implementation

Uses Dos;

function MouseReset: boolean; assembler;

asm
  MOV AX, 00h
  INT 33h
end;

procedure EnableMouseDriver; assembler;

asm
  MOV AX, 20h
  INT 33h
end;

function DisableMouseDriver: boolean;


var
  R: registers;

begin
  R.AX := $1F;
  Intr($33, R);
  DisableMouseDriver := (R.AX AND $001F) = $001F;
end;

function MouseDriverVersion: word;
var
  R: registers;

begin
  R.AX := $24;
  Intr($33, R);
  MouseDriverVersion := R.BX;
end;

procedure ShowMouseCursor; assembler;

asm
  MOV AX, 01h
  INT 33h
end;

procedure HideMouseCursor; assembler;

asm
  MOV AX, 02h
  INT 33h
end;

procedure SetMousePosition; assembler;

asm
  MOV AX, 04h
  MOV CX, X
  MOV DX, Y
  INT 33h
end;

procedure SetMouseHorizontalMaxMinPosition; assembler;

asm
  MOV AX, 07h
  MOV CX, Max
  MOV DX, Min
  INT 33h
end;

procedure SetMouseVerticalMaxMinPosition; assembler;

asm
  MOV AX, 08h
  MOV CX, Max
  MOV DX, Min
  INT 33h
end;

procedure GetMousePosition;

var
  R: registers;

begin
  R.AX := 3;
  Intr($33, R);
  X := R.CX;
  Y := R.DX;
end;

procedure GetMousePress;

var
  R: registers;

begin
  R.AX := 3;
  Intr($33, R);
  B1 := (R.BX AND $01) = $01;
  B2 := (R.BX AND $04) = $04;
  B3 := (R.BX AND $02) = $02;
end;


procedure SetMouseTextCursor; assembler;

asm
  MOV AX, 0Ah;
  MOV BX, 00h;
  MOV CX, StartScreenMask;
  MOV DX, endScreenMask;
  INT 33h;
end;

procedure SetMouseGraphicsCursor;

var
  R: registers;

begin
  with r,NewCursor do
  	begin
  		R.AX := 09;
  		R.BX := 00;
  		R.CX := 00;
  		R.ES := Seg(maska[0]);
  		R.DX := Ofs(maska[0]);
     end;
  Intr($33, R);
end;

function MouseIn;
var
	x,y:word;
begin
	GetMousePosition(x,y);

     x:=x div 2;

     if ( (x>x1) AND (x<x2) ) AND ( (y>y1) AND (y<y2) ) then MouseIn:=true else MouseIn:=FALSE;
end;

procedure sensitive(horiz,vert:word);assembler;
asm
  mov ax,15
  mov cx,horiz
  mov dx,vert
  int 33h
end;


end.