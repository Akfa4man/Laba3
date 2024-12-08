{$G+}
type
  tsound = record
  key: byte;
  note: word;
end;
const
  numsound=24;
  sound: array[1..numsound] of tsound=
  (
  (key:$2C; note:$11D0),(key:$2D; note:$0FDF),(key:$2E; note:$0E23),
  (key:$2F; note:$0D58),(key:$30; note:$0BE3),(key:$31; note:$0A97),
  (key:$32; note:$096F),(key:$1F; note:$10D0),(key:$20; note:$0EFA),
  (key:$22; note:$0C98),(key:$23; note:$0B39),(key:$24; note:$09FF),
  (key:$10; note:$08E8),(key:$11; note:$07EF),(key:$12; note:$0711),
  (key:$13; note:$06AC),(key:$14; note:$05F1),(key:$15; note:$054B),
  (key:$16; note:$04B8),(key:$03; note:$0868),(key:$04; note:$077D),
  (key:$06; note:$064C),(key:$07; note:$059C),(key:$08; note:$04FF)
  );
procedure playSound; assembler;
asm
  mov al, 0b6h
  out 43h, al
  mov al, dl
  out 42h, al
  mov al, dh
  out 42h, al
  in al, 61h
  or al, 00000011b
  out 61h, al
end;

procedure noSound; assembler;
asm
  in al, 61h
  and al, 11111100b
  out 61h, al
end;
begin
  asm
    @enter:
        xor ah, ah
        int 16h
        cmp ah, 1
        je @exit

        lea si, sound
        mov cx, numsound

    @compare:
        mov dl, [si+tsound.key]
        cmp ah, dl
        je @play
        add si, type(tsound)
        loop @compare
        jcxz @enter

    @play:
        mov dx, [si+tsound.note]
        call playSound

    @makesound:
        in al, 60h
        cmp al, $33
        jc @makesound

        call noSound
        jmp @enter

    @exit:
  end;
end.