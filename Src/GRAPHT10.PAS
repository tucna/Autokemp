Unit GraphT10;

Interface

type
     Pword = ^word;

	Procedure Init320x200;
	Procedure Init80x25Text;
	Procedure PutPixel(X,Y:Word;Barva:Byte;lvseg:word);
	Function  GetPixel(X,Y:Word;lvseg:word):Byte;
	Procedure SetPalette(Barva,Cervena,Zelena,Modra:Byte);
     Procedure SetPaletteEx(soubor:string);
	Procedure GetPalette(Barva:Byte; Var Cervena,Zelena,Modra:Byte);
	Procedure HorLine(x,y,delka:word;barva:byte;lvseg:word);
     Procedure VertLine(x,y,delka:word;barva:byte;lvseg:word);
	Procedure SetBuff(buff:PWord;var AddrBuff:word);
     Procedure FreeBuff(buff:Pword);
     Procedure Flip(od,kam:word);
     Procedure WaitForVGA;
     Procedure cls(lvseg:word);
     procedure getfont;
     procedure writetxt(x,y:word; txt:string; color:byte;lvseg:word);
     Procedure Bar(x1,y1,x2,y2:word;color:byte;lvseg:word);
	Procedure Line(x1,y1,x2,y2:integer;c:byte;lvseg:word);
     Procedure ShowBmp40x40(soub:string;pozX,pozY:word;transparent:byte;lvseg:word);
     Procedure ShowObr40x40(obr:array of byte;pozX,pozY:word;transparent:byte;lvseg:word);
     Procedure ConvertObrToArray40x40(bmp:string;var obr:array of byte);
     Procedure SeparatePalette(bitmapa:string;cil:string);
     Procedure ConvertBmpToObr40x40(bitmapa:string;obrazek:string);
     Procedure Tetragon(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);


const
	VGA=$A000;

var
	fofs,fseg:word;

Implementation

Function GetAddr(X,Y:Word):Word;
Begin
  GetAddr := 320*Y+X;
End;

Procedure Init320x200; Assembler;
  Asm
    MOV AX,$13
    INT $10
  End;

Procedure Init80x25Text; Assembler;
  Asm
    MOV AX,3
    INT $10
  End;

Procedure PutPixel;
Begin
  if (x<320) AND (y<200) then Mem[lvseg:GetAddr(X,Y)] := Barva;
End;

Function GetPixel;
Begin
  GetPixel := Mem[lvseg:GetAddr(X,Y)];
End;

Procedure SetPalette; Assembler;
  Asm
    MOV AX,$1010
    MOV BH,0
    MOV BL,Barva
    MOV DH,Cervena
    MOV CH,Zelena
    MOV CL,Modra
    INT $10
  End;

Procedure SetPaletteEx;
var
	paleta:file of byte;
     r,g,b,i:byte;
begin
	assign(paleta,soubor);
     reset(paleta);

     i:=0;

     repeat
     	read(paleta,r);
          read(paleta,g);
          read(paleta,b);
          SetPalette(i,r,g,b);
          i:=i+1;
    until eof(paleta);

    close(paleta);
end;

Procedure GetPalette; Assembler;
  Asm
    PUSH DS         { Tohle by slo jednodusejc pres tu nuitu Dos             }
    MOV AX,$1015    {   R.AX := $1015;                                       }
    MOV BH,0        {   R.BH := 0;                                           }
    MOV BL,Barva    {   R.BL := Barva;                                       }
    INT $10         {   INTR($10,R);                                         }
    LDS SI,Cervena  {   Cervena := R.DH                                      }
    MOV [SI],DH     {   Zelena := R.DL                                       }
    LDS SI,Zelena   {   Modra := R.CL                                        }
    MOV [SI],CH
    LDS SI,Modra
    MOV [SI],CL
    POP DS
  End;

Procedure HorLine;
begin
    fillchar(mem[lvseg:(y*320)+x],delka,barva);
end;

Procedure VertLine;
var
	i:word;
begin
	for i:=y to (delka+y) do mem[lvseg:(i*320)+x]:=barva;
end;

Procedure SetBuff;
begin
    GetMem(buff,64000);
    AddrBuff:=seg(buff^);
end;

Procedure FreeBuff;
begin
    FreeMem(buff,64000);
end;

Procedure Flip; Assembler;
asm
	push DS
     mov ax,[od]
     mov DS, AX
     xor SI,SI
     mov AX,[kam]
     mov ES, AX
     xor DI,DI
     mov CX,16000
     db 66h
     rep movsw
     pop DS
end;

Procedure WaitForVGA; Assembler;
asm
	mov DX,03DAh
     @@1: in AL, DX
     test AL,8
     jz @@1
end;

procedure cls; assembler;
asm
  mov es,[lvseg]
  xor di,di
  xor ax,ax
  mov cx,320*200/2
  rep stosw
end;

procedure getfont; assembler;
asm
  mov ax,1130h;
  mov bh,1;
  int 10h;
  mov fseg,es;
  mov fofs,bp;
end;

procedure writetxt;
var i,j,k:byte;
begin
  for i:=1 to length(txt) do
  	for j:=0 to 7 do
		for k:=0 to 7 do
    			if ((mem[fseg:fofs+ord(txt[i])*8+j] shl k) and 128) <> 0 then mem[lvseg:(y+j)*320+(i*8)+x+k]:=color;
end;

procedure Bar;
var
	i:word;
begin
	for i:=y1 to y2 do horline(x1,i,x2-x1,color,lvseg);
end;

procedure swapint(var x,y: integer);
var dummy: integer;
begin
  dummy:=x;
  x:=y;
  y:=dummy;
end;

procedure Line;
var p,dx,dy,ainc,binc,xinc,yinc,x,y: integer;
begin
  if(abs(x2-x1) < abs(y1-y2)) then begin
    if (y1 >y2) then begin
      swapint(y1,y2);
      swapint(x1,x2);
    end;
    if (x2 > x1) then xinc:=1
                 else xinc:=-1;
    dy:=y2-y1;
    dx:=abs(x2-x1);
    p:=2*dx-dy;
    ainc:=2*(dx-dy);
    binc:=2*dx;
    x:=x1;y:=y1;
    putpixel(x,y,c,lvseg);
    for y:=y1+1 to y2 do begin
      if (p>=0) then begin
        inc(x,xinc);
        inc(p,ainc);
      end
      else inc(p,binc);
       putpixel(x,y,c,lvseg);
    end;
  end
   else begin
    if (x1>x2) then begin
      swapint(x1,x2);
      swapint(y1,y2);
    end;
    if (y2>y1) then yinc:=1
    else yinc:=-1;
    dx:=x2-x1;
    dy:=abs(y2-y1);
    p:=2*dy-dx;
    ainc:=2*(dy-dx);
    binc:=2*dy;
    x:=x1;y:=y1;
    putpixel(x,y,c,lvseg);
    for x:=x1+1 to x2 do begin
      if (p>=0) then begin
        inc(y,yinc);
        inc(p,ainc);
      end
      else inc(p,binc);
      putpixel(x,y,c,lvseg);
    end;
  end;
end;

Procedure ShowBmp40x40;
var
	obr:file of byte;
     obrazek:array[1..40,1..40] of byte;

     r,g,b,a:byte; {a= michani alfa}
     i:integer;
     x,y:word;
begin
     i:=-1;
     x:=1;
     y:=1;

	assign(obr,soub);
     reset(obr);


     seek(obr,54);

     repeat
          i:=i+1;
     	read(obr,b);
     	read(obr,g);
     	read(obr,r);
          read(obr,a);

          r:=r div 4;
          g:=g div 4;
          b:=b div 4;

          SetPalette(i,r,g,b);
     until i=255;

     i:=0;

     repeat
     	read(obr,a); {a nebylo drive pouzito}
          obrazek[x,y]:=a;
          i:=i+1;
          x:=x+1;
          if x=41 then
          	begin
                   x:=1;
                   y:=y+1;
               end;
     until eof(obr);

     close(obr);

     for a:=1 to 12 do
     	for x:=1 to 40 do
     		for y:=1 to 40 do if obrazek[x,y]<>transparent then PutPixel(pozX+x,pozY+40-y,obrazek[x,y],lvseg);
end;

procedure ShowObr40x40;
var
	ObrX,ObrY,o:word;
begin
	ObrX:=PozX;
     ObrY:=PozY;

	for o:=0 to 1599 do
		begin
			if obr[o]<>transparent then PutPixel(ObrX,ObrY,obr[o],lvseg);
               ObrX:=ObrX+1;
          	if ObrX=PozX+40 then begin ObrX:=PozX;ObrY:=ObrY+1; end;
          end;
end;

Procedure ConvertObrToArray40x40;
var
	bitmapa:file of byte;

     BarvaPixelu:byte;

     ObrX,DefX:word;
begin
	assign(bitmapa,bmp);
     reset(bitmapa);

     ObrX:=1560;
	Defx:=1560;

     repeat
     	read(bitmapa,BarvaPixelu);

          obr[ObrX]:=BarvaPixelu;

          ObrX:=ObrX+1;
          if ObrX=(DefX+40) then
			begin
               	DefX:=DefX-40;
                    ObrX:=DefX;
			end;
     until eof(bitmapa);

     close(bitmapa);
end;

procedure SeparatePalette;
var
	zdrojF,cilF:file of byte;
     i:integer;
     r,g,b,a:byte; {a= michani alfa}

begin
	assign(zdrojF,bitmapa);
     assign(cilF,cil);

     reset(zdrojF);
     rewrite(cilF);

     seek(zdrojF,54);
     i:=-1;

     repeat
          i:=i+1;
     	read(zdrojF,b);
     	read(zdrojF,g);
     	read(zdrojF,r);
          read(zdrojF,a);

          r:=r div 4;
          g:=g div 4;
          b:=b div 4;

          write(cilF,r);
          write(cilF,g);
          write(cilF,b);
     until i=255;

     close(zdrojF);
     close(cilF);
end;

procedure ConvertBmpToObr40x40;
var
	zdrojF,cilF:file of byte;
     a:byte;
begin
	assign(zdrojF,bitmapa);
     assign(cilF,obrazek);

     reset(zdrojF);
     rewrite(cilF);

     seek(zdrojF,1078);

     repeat
     	read(zdrojF,a);
          write(cilF,a);
     until eof(zdrojF);

     close(zdrojF);
     close(cilF);
end;

Procedure Tetragon(X1,Y1,X2,Y2,X3,Y3 : Integer;
                 Color : Byte; VideoSeg : Word); Assembler;
Var
 XX1  : Longint;
 XX2  : Longint;
 XX3  : Longint;
 DX1  : Longint;
 DX2  : Longint;
 DX3  : Longint;
 Y  : Integer;
 CX1,CX2 : LongInt;
 CDWord : LongInt;

Asm
  cld
   mov  al,[color]
   mov  ah,al
   mov  bx,ax
 db $66; shl  ax,16
   mov  ax,bx
 db $66; mov  [word ptr cdword],ax

   mov  ax,[x1]    { inicializace registr– }
   mov  bx,[y1]
   mov  cx,[x2]
   mov  dx,[y2]
   mov  si,[x3]
   mov  di,[y3]

   cmp  bx,dx    { porovn n¡ y1 a y2 }
   jle  @@ok_first_1
   xchg ax,cx
   xchg bx,dx
@@ok_first_1:
   cmp  bx,di    { porovn n¡ y2 a y3 }
   jle  @@ok_first_2
   xchg ax,si
   xchg bx,di
@@ok_first_2:
   cmp  dx,di    { porovn n¡ y1 a y3 }
   jle  @@ok_first_3
   xchg cx,si
   xchg dx,di
@@ok_first_3:
   mov  [x1],ax  { uprava p–vodn¡ch hodnot podle velikosti }
   mov  [y1],bx
   mov  [x2],cx
   mov  [y2],dx
   mov  [x3],si
   mov  [y3],di

   cmp  bx,di
   jne  @@nonflat

   test bx,bx
   jl  @@alllines
   cmp  bx,199
   jg  @@alllines
   mov  di,bx
   shl  di,6
   shl  bx,8
   add  di,bx
   mov  es,[videoseg]
   mov  ax,[x1]
   cmp  ax,[x2]
   jle  @@fl1
   mov  ax,[x2]
@@fl1:
   cmp  ax,[x3]
   jle  @@fl2
   mov  ax,[x3]
@@fl2:
   mov  bx,[x1]
   cmp  bx,[x2]
   jge  @@fl3
   mov  bx,[x2]
@@fl3:
   cmp  bx,[x3]
   jge  @@fl4
   mov  bx,[x3]
@@fl4:
   test ax,ax
   jge  @@fl5
   test bx,bx
   jge  @@fl5
   jmp  @@alllines
@@fl5:
   cmp  ax,319
   jle  @@fl6
   cmp  bx,319
   jle  @@fl6
   jmp  @@alllines
@@fl6:
   test ax,ax
   jge  @@fl7
   sub  ax,ax
@@fl7:
   cmp  bx,319
   jle  @@fl8
   mov  bx,319
@@fl8:
   add  di,ax
   mov  cx,bx
   sub  cx,ax
   inc  cx
   cld
 db $66; mov  ax,[word ptr cdword]
   jcxz @@fl10
   test di,$0001
   jz  @@notone_1
   mov  [es:di],al
   inc  di
   dec  cx
   jz  @@fl10
@@notone_1:
   cmp  cx,2
   jb  @@nottwo_1
   test di,$0002
   jz  @@nottwo_1
   mov  [es:di],ax
   add  di,2
   sub  cx,2
   jz  @@fl10
@@nottwo_1:
   shr  cx,1
   db $0f, $92, $c3
   shr  cx,1
 db $66; rep  stosw
   jnc  @@fl9
   mov  [es:di],ax
   add  di,2
@@fl9:
   or  bl,bl
   jz  @@fl10
   mov  [es:di],al
   inc  di
@@fl10:
   jmp  @@alllines
@@nonflat:
   db $66, $0f, $bf, $46, offset x1 { movsx eax,[x1] }
   db $66, $0f, $bf, $5e, offset x2 { movsx ebx,[x2] }
   db $66, $0f, $bf, $4e, offset x3 { movsx ecx,[x3] }

 db $66; sal  ax,16
 db $66; sal  bx,16
 db $66; sal  cx,16

 db $66; mov  [word ptr xx1],ax
 db $66; mov  [word ptr xx2],bx
 db $66; mov  [word ptr xx3],cx

   mov  ax,[y1]
   cmp  ax,[y2]
   je  @@eq1

 db $66; mov  ax,[word ptr xx2]
 db $66; mov  bx,[word ptr xx1]
 db $66; sub  ax,bx

 db $66; cwd
   mov     bx,[y2]
   sub  bx,[y1]
   db $66, $0f, $bf, $cb    { movsx ecx,bx }
 db $66; idiv cx
 db $66; mov  [word ptr dx1],ax
   jmp  @@do2
@@eq1:
 db $66; xor  ax,ax
 db $66; mov  [word ptr dx1],ax
@@do2:
   mov  ax,[y2]
   cmp  ax,[y3]
   je  @@eq2

 db $66; mov  ax,[word ptr xx3]
 db $66; mov  bx,[word ptr xx2]
 db $66; sub  ax,bx

 db $66; cwd
   mov     bx,[y3]
   sub  bx,[y2]
   db $66, $0f, $bf, $cb    { movsx ecx,bx }
 db $66; idiv cx
 db $66; mov  [word ptr dx2],ax
   jmp  @@do3
@@eq2:
 db $66; xor  ax,ax
 db $66; mov  [word ptr dx2],ax
@@do3:
   mov  ax,[y3]
   cmp  ax,[y1]
   je  @@eq3

 db $66; mov  ax,[word ptr xx3]
 db $66; mov  bx,[word ptr xx1]
 db $66; sub  ax,bx

 db $66; cwd
   mov     bx,[y3]
   sub  bx,[y1]
   db $66, $0f, $bf, $cb    { movsx ecx,bx }
 db $66; idiv cx
 db $66; mov  [word ptr dx3],ax
   jmp  @@dofill
@@eq3:
 db $66; xor  ax,ax
 db $66; mov  [word ptr dx3],ax
@@dofill:
   mov  ax,[y1]
   cmp  ax,[y2]
   jne  @@diff

 db $66; mov  ax,[word ptr xx1]
 db $66; mov  bx,[word ptr xx2]
 db $66; mov  cx,[word ptr dx1]
 db $66; mov  dx,[word ptr dx1]
 db $66; cmp  cx,dx
   jge  @@ok11
 db $66; xchg ax,bx
@@ok11:
 db $66; mov  [word ptr cx1],ax
 db $66; mov  [word ptr cx2],bx
   jmp  @@done
@@diff:
 db $66; mov  ax,[word ptr xx1]
 db $66; mov  [word ptr cx1],ax
 db $66; mov  [word ptr cx2],ax
@@done:
   mov  ax,[y1]
   mov  [y],ax

   test ax,ax
   jge  @@okline
   sub  ax,ax
@@okline:
   mov  di,ax
   shl  ax,6
   shl  di,8
   add  di,ax
@@go_on:
   mov  es,[videoseg]
   cld
@@lineloop:
   mov  ax,[y]
   cmp  ax,0
   jl  @@nextline
   cmp  ax,199
   jg  @@alllines

 db $66; mov  ax,[word ptr cx1]
 db $66; mov  bx,[word ptr cx2]
 db $66; cmp  ax,bx
 db $66; jle  @@ok
 db $66; xchg ax,bx
@@ok:
 db $66; xor  cx,cx
 db $66; sar  ax,16
 db $66; adc  ax,cx
 db $66; sar  bx,16
 db $66; adc  bx,cx
   cmp  ax,0
   jge  @@ok1_1
   cmp  bx,0
   jge  @@ok1_1
   jmp  @@nextline
@@ok1_1:
   cmp  ax,319
   jle  @@ok1_2
   cmp  bx,319
   jle  @@ok1_2
   jmp  @@nextline
@@ok1_2:
   test ax,ax
   jge  @@ok1
   sub  ax,ax
@@ok1:
   cmp  ax,319
   jle  @@ok2
   mov  ax,319
@@ok2:
   test bx,bx
   jge  @@ok3
   sub  bx,bx
@@ok3:
   cmp  bx,319
   jle  @@ok4
   mov  bx,319
@@ok4:
   mov  cx,bx
   sub  cx,ax
   inc  cx
   mov  si,di
   add  di,ax

 db $66; mov  ax,[word ptr cdword]
   jcxz @@skip2
   test di,$0001
   jz  @@notone
   mov  [es:di],al
   inc  di
   dec  cx
   jz  @@skip2
@@notone:
   cmp  cx,2
   jb  @@nottwo
   test di,$0002
   jz  @@nottwo
   mov  [es:di],ax
   add  di,2
   sub  cx,2
   jz  @@skip2
@@nottwo:
   shr  cx,1
   db $0f, $92, $c3   { setc bl }
   shr  cx,1
 db $66; rep  stosw
   jnc  @@skip1
   mov  [es:di],ax
   add  di,2
@@skip1:
   or  bl,bl
   jz  @@skip2
   mov  [es:di],al
   inc  di
@@skip2:
   mov  di,si
@@nextline:
   mov  ax,[y]
   test ax,ax
   jl  @@nextline_2
   add  di,320
@@nextline_2:
   cmp  ax,[y1]
   jl  @@line2
   cmp  ax,[y2]
   jge  @@line2
 db $66; mov  ax,[word ptr dx1]
 db $66; add  [word ptr cx2],ax
@@line2:
   mov  ax,[y]
   cmp  ax,[y1]
   jl  @@line3
   cmp  ax,[y3]
   jge  @@line3
 db $66; mov  ax,[word ptr dx3]
 db $66; add  [word ptr cx1],ax
@@line3:
   mov  ax,[y]
   cmp  ax,[y2]
   jl  @@exit
   cmp  ax,[y3]
   jg  @@exit
 db $66; mov  ax,[word ptr dx2]
 db $66; add  [word ptr cx2],ax
@@exit:
   inc  [y]
   mov  ax,[y]
   cmp  ax,[y3]
   jle  @@lineloop
@@alllines:
End;


End.