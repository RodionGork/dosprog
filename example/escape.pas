program escape;

uses crt;

const rows = 21;
  cols = 25;

type field = array[1..cols, 1..rows] of boolean;

procedure centered(y:byte; s:string);
begin
  gotoxy((80-length(s)) div 2, y);
  write(s);
end;

procedure intro;
begin
  textcolor(yellow);
  textbackground(black);
  clrscr;
  centered(3, 'E S C A P E !');
  centered(5, 'As soon as you kissed the princess, alarm sounded');
  centered(6, 'The castle starts trembling, parts of the floor');
  centered(7, 'fall down every few seconds...');
  centered(9, 'Use arrow keys to reach exit at upper-left corner!');
  centered(11, 'Press enter!');
  readln;
end;

procedure wrcell(x, y: byte; s: string; bg, fg: byte);
begin
  gotoxy(x*3+2, y+2);
  textcolor(fg);
  textbackground(bg);
  write(s);
end;

procedure blowup(var arr: field);
var i, x, y: byte;
begin
  for i := 1 to 5 do begin
    x := random(cols) + 1;
    y := random(rows) + 1;
    if ((x <> 1) or (y <> 1)) and ((x <> cols) or (y <> rows)) then begin
      arr[x, y] := true;
      wrcell(x, y, '**', red, yellow);
    end;
  end;
end;

procedure play;
var x, y: byte;
  ch : char;
  arr: field;
  killed: boolean;
begin
  clrscr;
  for y := 1 to rows do
    for x := 1 to cols do begin
      arr[x, y] := false;
      wrcell(x, y, '--', black, lightgray);
    end;
  wrcell(1, 1, 'EX', lightgreen, black);
  x := cols;
  y := rows;
  killed := false;
  blowup(arr);
  repeat
    wrcell(x, y, ':O', black, lightblue);
    repeat
      ch := readkey;
    until ch > ' ';
    wrcell(x, y, '--', black, lightgray);
    if (ch = 'H') and (y > 1) then
      dec(y)
    else if (ch = 'K') and (x > 1) then
      dec(x)
    else if (ch = 'M') and (x < cols) then
      inc(x)
    else if (ch = 'P') and (y < rows) then
      inc(y);
    if arr[x, y] then
      killed := true
    else begin
      blowup(arr);
      if arr[x, y] then
        killed := true;
    end;
  until killed or (x = 1) and (y = 1);
  textbackground(black);
  if not killed then begin
    textcolor(lightgreen);
    centered(1, 'Well done! press enter...');
  end else begin
    textcolor(lightred);
    centered(1, 'You are dead, dead, dead! press enter...');
  end;
  readln;
end;

function askstop: boolean;
var ch: char;
begin
  clrscr;
  centered(12, 'Play again? (y/n)');
  repeat
    ch := upcase(readkey);
  until (ch = 'Y') or (ch = 'N');
  askstop := (ch = 'N');
end;

begin
  randomize;
  repeat
    intro;
    play;
  until askstop;
end.