uses grapht10,crt,mouseT10;

{objecty}
type
	TBitMap=array[0..255] of byte;

	GrMenu=object
     	polozky:array[1..4] of TBitMap;
          soubory:array[1..4] of string;
          stisknuty:array[1..4] of boolean;
          pol:TBitmap;
          lvseg:word;
          procedure NaplnPolozky(soub1,soub2,soub3,soub4:string);
          procedure VykresliObrazek(obrazek:TBitMap;x:word);
          procedure Show;
     end;

	GrWindow=object
         x1,y1,x2,y2,lvseg:word;
         BarvaInLine,BarvaOutLine,BarvaTXT:byte;
         visible:boolean;
         txt:string;
         posun:boolean;
         function IsVisible:boolean;
         procedure show;
     end;

     procedure GrMenu.NaplnPolozky;
     var
     	i,o:byte;
          obr:file of byte;
          pix:byte;
     begin
     	soubory[1]:=soub1;
     	soubory[2]:=soub2;
     	soubory[3]:=soub3;
     	soubory[4]:=soub4;

     	for i:=1 to 4 do
          	begin
               	assign(obr,'obr\'+soubory[i]);
                    reset(obr);

                    for o:=0 to 255 do
                    	begin
                             read(obr,pix);
                             pol[o]:=pix;
                         end;

                    polozky[i]:=pol;
                    close(obr);
               end;
     end;

     procedure GrMenu.VykresliObrazek;
     var
     	y,o,i,DefX:byte;
     begin
     	y:=2;
          DefX:=x;

          for o:=0 to 255 do
          	begin
               	if obrazek[o]<>144 then PutPixel(x,19-y,obrazek[o],lvseg);
                    x:=x+1;
                    if x=DefX+16 then
					begin
                             x:=defX;y:=y+1;
					end;
               end;

     end;

     procedure GrMenu.Show;
     var
     	i:byte;
	begin
     	HorLine(0,0,320,80,lvseg);
     	HorLine(0,1,320,81,lvseg);
          HorLine(0,18,320,81,lvseg);
     	HorLine(0,19,320,80,lvseg);

          VertLine(0,0,18,80,lvseg);
          VertLine(1,1,17,81,lvseg);
          VertLine(18,1,17,81,lvseg);
          VertLine(19,0,18,80,lvseg);
          VertLine(20,1,17,81,lvseg);
          VertLine(37,1,17,81,lvseg);
          VertLine(38,0,18,80,lvseg);
          VertLine(39,1,17,81,lvseg);
          VertLine(56,1,17,81,lvseg);
          VertLine(57,0,18,80,lvseg);
          VertLine(58,1,17,81,lvseg);
          VertLine(75,1,17,81,lvseg);
          VertLine(76,0,18,80,lvseg);
          VertLine(77,1,17,81,lvseg);
          VertLine(318,1,17,81,lvseg);
          VertLine(319,0,18,80,lvseg);

          bar(78,2,318,17,80,lvseg);

          for i:=1 to 4 do VykresliObrazek(polozky[i],i*19-17);

          for i:=1 to 4 do
          	if stisknuty[i] then SetPalette(167+i,40,10,10) else SetPalette(167+i,29,37,32);

     end;

     function GrWindow.IsVisible;
     begin
     	IsVisible:=visible;
     end;

     procedure GrWindow.Show;
     begin
         	Bar(x1,y1,x2,y2+14,0,lvseg);

     	{vnejsi okraj}
		HorLine(x1,y1,x2-x1+1,barvainline,lvseg);
     	Horline(x1,y1+15,x2-x1+1,barvainline,lvseg);
     	Horline(x1,y2+15,x2-x1+1,barvainline,lvseg);

     	VertLine(x1,y1,y2-y1+15,barvainline,lvseg);
     	VertLine(x2,y1,y2-y1+15,barvainline,lvseg);

     	{vnitrni okraj}
     	HorLine(x1+1,y1-1,x2-x1+1,barvaoutline,lvseg);
     	HorLine(x1+1,y1+14,x2-x1-2+1,barvaoutline,lvseg);
     	Horline(x1+1,y2+14,x2-x1-2+1,barvaoutline,lvseg);

     	VertLine(x1+1,y1+1,12,barvaoutline,lvseg);
     	VertLine(x1+1,y1+16,y2-y1-3,barvaoutline,lvseg);
     	VertLine(x2+1,y1-1,y2-y1+15,barvaoutline,lvseg);

     	{text}
     	writetxt(x1+1,y1+4,txt,barvaTXT,lvseg);
     end;


var
	BackBuff:Pword;
     BackAddr:word;


{procedure NaplnObrazek(var obrazek:array of byte;soubor:string);
var
	ObrX,BarvaPixelu:byte;
     soub:file of byte;

begin
	assign(soub,soubor);
     reset(soub);

     ObrX:=1;

     repeat
     	read(soub,BarvaPixelu);
		obrazek[ObrX]:=BarvaPixelu;
          ObrX:=ObrX+1;
     until eof(soub);

     close(soub);
end; }

procedure VykresliObr(pole:array of byte;VykX,VykY:word);
var
	ObrX,ObrY,o:word;
begin
	ObrX:=VykX;
     ObrY:=VykY;

	for o:=0 to 1599 do
		begin
			if pole[o]<>144 then PutPixel(ObrX,ObrY,pole[o],BackAddr);
               ObrX:=ObrX+1;
          	if ObrX=VykX+40 then begin ObrX:=VykX;ObrY:=ObrY+1; end;
          end;
end;


const
	podklad:array[1..50,1..55] of byte=(
{     (9 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,10),
     (5 ,2 ,1 ,2 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,1 ,3 ,1 ,2 ,1 ,2 ,1 ,2 ,7 ),
     (5 ,2 ,2 ,2 ,2 ,2 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,2 ,4 ,1 ,7 ),
     (5 ,2 ,3 ,3 ,3 ,2 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,2 ,2 ,2 ,1 ,7 ),
     (5 ,2 ,3 ,3 ,3 ,2 ,2 ,1 ,3 ,2 ,1 ,2 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,3 ,1 ,4 ,1 ,7 ),
     (5 ,2 ,2 ,2 ,2 ,2 ,1 ,3 ,2 ,1 ,3 ,1 ,2 ,1 ,2 ,4 ,4 ,1 ,2 ,1 ,3 ,2 ,1 ,7 ),
     (5 ,1 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,4 ,1 ,1 ,1 ,2 ,1 ,4 ,4 ,1 ,1 ,1 ,1 ,3 ,1 ,7 ),
     (5 ,1 ,1 ,3 ,3 ,1 ,2 ,1 ,4 ,1 ,2 ,1 ,3 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,7 ),
     (5 ,4 ,2 ,1 ,1 ,1 ,2 ,3 ,1 ,4 ,1 ,2 ,2 ,3 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,7 ),
     (5 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,2 ,1 ,2 ,1 ,4 ,1 ,2 ,1 ,2 ,7 ),
     (5 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,2 ,2 ,1 ,2 ,1 ,1 ,1 ,4 ,1 ,2 ,1 ,3 ,1 ,7 ),
     (5 ,1 ,1 ,3 ,1 ,2 ,1 ,4 ,4 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,2 ,1 ,4 ,1 ,2 ,1 ,2 ,7 ),
     (5 ,2 ,1 ,3 ,1 ,2 ,2 ,4 ,4 ,1 ,2 ,1 ,1 ,3 ,1 ,3 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,7 ),
     (5 ,1 ,2 ,1 ,2 ,1 ,1 ,2 ,1 ,3 ,1 ,3 ,2 ,1 ,1 ,2 ,1 ,1 ,3 ,1 ,1 ,2 ,1 ,7 ),
     (12,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,8 ,11)
	);}
(9,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,10),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,4,3,2,1,1,1,2,2,1,1,1,3,1,1,2,1,1,1,1,2,1,2,1,2,1,1,1,1,1,1,7),
(5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7),
(12,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,11)
);

	objekty:array[1..50,1..55] of byte=( {viditelna x..5,y..8}
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,1,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,1,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
);
{
 podklad
     1,2,3,4-trava
     5,6,7,8,9-okraj

 objekty
     1-chatka
     2-stan
     3,4-strom
     5,6,7,8,9,10,11,12-cesta
}

var
     soubor:file of byte;
{vrch}
	chatka:array[1..1600] of byte;
	stan:array[1..1600] of byte;
     strom1:array[1..1600] of byte;
	strom2:array[1..1600] of byte;
	cesta1:array[1..1600] of byte;
	cesta2:array[1..1600] of byte;
	cesta3:array[1..1600] of byte;
	cesta4:array[1..1600] of byte;
	cesta5:array[1..1600] of byte;
	cesta6:array[1..1600] of byte;
	cesta7:array[1..1600] of byte;
	cesta8:array[1..1600] of byte;
{podklad}
	trava1:array[1..1600] of byte;
	trava2:array[1..1600] of byte;
	trava3:array[1..1600] of byte;
	trava4:array[1..1600] of byte;
     okraj1:array[1..1600] of byte;
     okraj2:array[1..1600] of byte;
     okraj3:array[1..1600] of byte;
     okraj4:array[1..1600] of byte;
     okraj5:array[1..1600] of byte;
     okraj6:array[1..1600] of byte;
     okraj7:array[1..1600] of byte;
     okraj8:array[1..1600] of byte;

     cisloSouboru,x,y,BarvaPixelu:byte;
     o,ObrX,ObrY:word;

     prekresli:boolean;
     MapaX,MapaY:byte;

     mousePosX,MousePosY:word;
     b1,b2,b3:boolean;

     text:string;

     stMapaX,stMapaY:byte;

     Mapa:GrWindow;
     Menu:GrMenu;
     StMouseX,stMouseY:word;
     defX:word;

     r,g,b:byte;

begin
	Init320x200;

    	GetMem(BackBuff,64000);
    	BackAddr:=seg(BackBuff^);

     GetFont;

     writeTxt(0,0,'Loading...',123,VGA);

     MapaX:=1;
     MapaY:=1;
     prekresli:=TRUE;

     SetPaletteEx('paleta.p');
{     NaplnObrazek(chatka,'chatka.obr');}

     for  cisloSouboru:=1 to 24 do
		begin
     		ObrX:=1561;
			Defx:=1561;
     		case cisloSouboru of
     			1: assign(soubor,'obr\chatka.obr');
     			2: assign(soubor,'obr\stan.obr');
     			3: assign(soubor,'obr\strom1.obr');
     			4: assign(soubor,'obr\strom2.obr');
                    5: assign(soubor,'obr\trava1.obr');
                    6: assign(soubor,'obr\trava2.obr');
                    7: assign(soubor,'obr\trava3.obr');
                    8: assign(soubor,'obr\trava4.obr');
                    9: assign(soubor,'obr\cesta1.obr');
                    10: assign(soubor,'obr\cesta2.obr');
                    11: assign(soubor,'obr\cesta3.obr');
                    12: assign(soubor,'obr\cesta4.obr');
                    13: assign(soubor,'obr\cesta5.obr');
                    14: assign(soubor,'obr\cesta6.obr');
                    15: assign(soubor,'obr\cesta7.obr');
                    16: assign(soubor,'obr\cesta8.obr');
                    17: assign(soubor,'obr\okraj1.obr');
                    18: assign(soubor,'obr\okraj2.obr');
                    19: assign(soubor,'obr\okraj3.obr');
                    20: assign(soubor,'obr\okraj4.obr');
                    21: assign(soubor,'obr\okraj5.obr');
                    22: assign(soubor,'obr\okraj6.obr');
                    23: assign(soubor,'obr\okraj7.obr');
                    24: assign(soubor,'obr\okraj8.obr');
     		end;

               reset(soubor);

     		repeat
     			read(soubor,BarvaPixelu);
                    case cisloSouboru of
                        1: chatka[ObrX]:=BarvaPixelu;
                        2: stan[ObrX]:=BarvaPixelu;
                        3: strom1[ObrX]:=BarvaPixelu;
                        4: strom2[ObrX]:=BarvaPixelu;
                        5: trava1[ObrX]:=BarvaPixelu;
                        6: trava2[ObrX]:=BarvaPixelu;
                        7: trava3[ObrX]:=BarvaPixelu;
                        8: trava4[ObrX]:=BarvaPixelu;
                        9: cesta1[ObrX]:=BarvaPixelu;
                        10: cesta2[ObrX]:=BarvaPixelu;
                        11: cesta3[ObrX]:=BarvaPixelu;
                        12: cesta4[ObrX]:=BarvaPixelu;
                        13: cesta5[ObrX]:=BarvaPixelu;
                        14: cesta6[ObrX]:=BarvaPixelu;
                        15: cesta7[ObrX]:=BarvaPixelu;
                        16: cesta8[ObrX]:=BarvaPixelu;
                        17: okraj1[ObrX]:=BarvaPixelu;
                        18: okraj2[ObrX]:=BarvaPixelu;
                        19: okraj3[ObrX]:=BarvaPixelu;
                        20: okraj4[ObrX]:=BarvaPixelu;
                        21: okraj5[ObrX]:=BarvaPixelu;
                        22: okraj6[ObrX]:=BarvaPixelu;
                        23: okraj7[ObrX]:=BarvaPixelu;
                        24: okraj8[ObrX]:=BarvaPixelu;
                    end;
          		ObrX:=ObrX+1;
                    if ObrX=(DefX+40) then
					begin
               			DefX:=DefX-40;
                    		ObrX:=DefX;
					end;
     		until eof(soubor);

     		close(soubor);
     	end;

     showmousecursor;

     stMapaX:=0;
     stMapaY:=0;

     Mapa.x1:=240;
     Mapa.y1:=2;
     Mapa.x2:=318;
     Mapa.y2:=62;

     Mapa.BarvaInLine:=8;
     Mapa.BarvaOutLine:=9;
     Mapa.Txt:='Mapa';
     Mapa.BarvaTXT:=254;
     Mapa.lvseg:=BackAddr;

     Menu.lvseg:=BackAddr;
     Menu.NaplnPolozky('menu1.obr','menu2.obr','menu3.obr','menu4.obr');
     Menu.Stisknuty[2]:=true;

     repeat
          stMouseX:=MousePosX;
          stMouseY:=MousePosY;
          GetMousePosition(MousePosX,MousePosY);
          GetMousePress(b1,b2,b3);

          MousePosx:=MousePosX div 2;

          if (b1) AND (MouseIn(2,2,75,17)) then
          	begin
               	case MousePosX of
					2..17:Menu.stisknuty[1]:=not Menu.Stisknuty[1];
                    	21..37:Menu.stisknuty[2]:=not Menu.Stisknuty[2];
                    	40..55:Menu.stisknuty[3]:=not Menu.Stisknuty[3];
                    	59..75:Menu.stisknuty[4]:=not Menu.Stisknuty[4];
               	end;
                    prekresli:=true;
               end;

          if (b1=FALSE) AND (mapa.posun) then
          	begin
               	SetPalette(8,5,24,29);
                    SetPalette(9,11,31,36);
                    Mapa.Posun:=FALSE;
               end;

          if (b1) AND ( (MouseIn(Mapa.x1,Mapa.y1,Mapa.x2,Mapa.y1+14)) OR (mapa.posun=TRUE) ) AND (menu.stisknuty[2]) then
			begin
               	Mapa.posun:=true;
                    prekresli:=true;
               end;

{          if (b1) AND ((MapaY+(MousePosY div 40)<>StMapaY) OR (MapaX+((MousePosX div 2) div 40)<>StMapaX)) then
			begin
                    StMapaY:=MapaY+(MousePosY div 40);
                    StMapaX:=MapaX+((MousePosX div 2) div 40);
                    case objekty[StMapaY,StMapaX] of
                    	0: text:='trava';
                         1: text:='chatka';
                         2: text:='stan';
                         5,6,7,8,9,10,11,12:text:='cesta';
                    end;
                    prekresli:=TRUE;
               end;}

		if (MousePosX>310) AND (MapaX<48) AND (mapa.posun=FALSE) then
          	begin
                   MapaX:=MapaX+1;
                   prekresli:=TRUE;
               end;

          if (MousePosX<10) AND (MapaX>1) AND (mapa.posun=FALSE) then
          	begin
                   MapaX:=MapaX-1;
                   prekresli:=TRUE;
               end;

          if (MousePosY>190) AND (MapaY<46) AND (mapa.posun=FALSE) then
          	begin
                   MapaY:=MapaY+1;
                   prekresli:=TRUE;
               end;

          if (MousePosY<10) AND (MapaY>1) AND (mapa.posun=FALSE) then
          	begin
                   MapaY:=MapaY-1;
                   prekresli:=TRUE;
               end;

          if prekresli then
          	begin
     			for x:=MapaX to (MapaX+7) do
     				for y:=MapaY to (MapaY+4) do
          				case podklad[y,x] of
               				1: VykresliObr(trava1,(x-MapaX)*40,(y-MapaY)*40);
               				2: VykresliObr(trava2,(x-MapaX)*40,(y-MapaY)*40);
               				3: VykresliObr(trava3,(x-MapaX)*40,(y-MapaY)*40);
               				4: VykresliObr(trava4,(x-MapaX)*40,(y-MapaY)*40);
               				5: VykresliObr(okraj1,(x-MapaX)*40,(y-MapaY)*40);
               				6: VykresliObr(okraj2,(x-MapaX)*40,(y-MapaY)*40);
               				7: VykresliObr(okraj3,(x-MapaX)*40,(y-MapaY)*40);
               				8: VykresliObr(okraj4,(x-MapaX)*40,(y-MapaY)*40);
               				9: VykresliObr(okraj5,(x-MapaX)*40,(y-MapaY)*40);
               				10: VykresliObr(okraj6,(x-MapaX)*40,(y-MapaY)*40);
               				11: VykresliObr(okraj7,(x-MapaX)*40,(y-MapaY)*40);
               				12: VykresliObr(okraj8,(x-MapaX)*40,(y-MapaY)*40);						end;

     			for x:=MapaX to (MapaX+7) do
     				for y:=MapaY to (MapaY+4) do
          				case objekty[y,x] of
               				1: VykresliObr(chatka,(x-MapaX)*40,(y-MapaY)*40);
               				2: VykresliObr(stan,(x-MapaX)*40,(y-MapaY)*40);
               				3: VykresliObr(strom1,(x-MapaX)*40,(y-MapaY)*40);
               				4: VykresliObr(strom2,(x-MapaX)*40,(y-MapaY)*40);
               				5: VykresliObr(cesta1,(x-MapaX)*40,(y-MapaY)*40);
               				6: VykresliObr(cesta2,(x-MapaX)*40,(y-MapaY)*40);
               				7: VykresliObr(cesta3,(x-MapaX)*40,(y-MapaY)*40);
               				8: VykresliObr(cesta4,(x-MapaX)*40,(y-MapaY)*40); {Proc pritam 1??}
               				9: VykresliObr(cesta5,(x-MapaX)*40,(y-MapaY)*40); {Proc pritam 1??}
               				10: VykresliObr(cesta6,(x-MapaX)*40,(y-MapaY)*40);
               				11: VykresliObr(cesta7,(x-MapaX)*40,(y-MapaY)*40);
               				12: VykresliObr(cesta8,(x-MapaX)*40,(y-MapaY)*40);
						end;
{          		writetxt(260,5,text,BackAddr,0);}
{				GrWindow(50,50,200,100,8,9,'Mapa',15,BackAddr);}

				if (Mapa.posun) AND (Menu.stisknuty[2]) then
          			begin
                    		SetPalette(9,50,10,10);
                    		SetPalette(8,40,10,10);
						Mapa.x1:=Mapa.X1+MousePosX-stMouseX;
                    		Mapa.x2:=Mapa.x2+MousePosX-stMouseX;
                              If Mapa.x2<78 then
                              	begin
                                       Mapa.x2:=78;
                                       Mapa.x1:=0;
                                   end;
                              if Mapa.x1>240 then
                              	begin
                                   	Mapa.x2:=318;
                                        Mapa.x1:=240;
                                   end;
                    		Mapa.y1:=Mapa.y1+MousePosY-stMouseY;
                    		Mapa.y2:=Mapa.y2+MousePosY-stMouseY;
                              If Mapa.y2<62 then
                              	begin
                                       Mapa.y1:=2;
                                       Mapa.y2:=62;
                                   end;
                              If Mapa.y1>124 then
                              	begin
                                       Mapa.y1:=124;
                                       Mapa.y2:=184;
                                   end;
          			end;

     			Menu.Show;
				if menu.stisknuty[2] then
					begin
						Mapa.Show;

                    		for x:=1 to 55	do
                    			for y:=1 to 50 do
                         			case objekty[y,x] of
                              			0: PutPixel(Mapa.x1+2+x-1+10,Mapa.y1+16+y-1+4,241,BackAddr);
                              			3,4: PutPixel(Mapa.x1+2+x-1+10,Mapa.y1+16+y-1+4,243,BackAddr);
                              			1: PutPixel(Mapa.x1+2+x-1+10,Mapa.y1+16+y-1+4,247,BackAddr);
                              			2: PutPixel(Mapa.x1+2+x-1+10,Mapa.y1+16+y-1+4,23,BackAddr);
                                   		5,6,7,8,9,10,11,12:PutPixel(Mapa.x1+2+x-1+10,Mapa.y1+16+y-1+4,35,BackAddr);
                              		end;

                    		{vysec}
                    		HorLine(Mapa.x1+10+MapaX,Mapa.y1+18+MapaY+1,9,254,BackAddr);
                    		HorLine(Mapa.x1+10+MapaX,Mapa.y1+18+MapaY+7,9,254,BackAddr);
                    		VertLine(Mapa.x1+10+MapaX,Mapa.y1+18+MapaY+1,6,254,BackAddr);
                    		VertLine(Mapa.x1+10+MapaX+9,Mapa.y1+18+MapaY+1,6,254,BackAddr);
                         end;
                    hidemousecursor;
                    waitforVGA;
                    flip(BackAddr,VGA);
                    showmousecursor;
               end;
          prekresli:=FALSE;
          delay(50);
     until keypressed;
     FreeMem(BackBuff,64000);
     Init80x25text;
end.