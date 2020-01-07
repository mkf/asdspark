with Ada.Integer_Text_IO;
with AsdinveLib; use AsdinveLib;
procedure AsdinveMain is
   procedure run is
      n : Positive range 2..10000;
   begin
      Ada.Integer_Text_IO.Get(n);
      declare
         a : arr (1..n);
      begin
         for i in a'Range loop
            Ada.Integer_Text_IO.Get(a(i));
         end loop;
         Ada.Integer_Text_IO.Put(result(arr(a)));
      end;
   end run;

begin
   run;
end AsdinveMain;
