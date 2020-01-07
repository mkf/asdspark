with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
with AsdanagLib; use AsdanagLib;
procedure AsdAnagMain is
   procedure run is
      lens : lens_t;
      s    : s_t;
      result : Boolean;
   begin
      for w in two_t loop
         Ada.Text_IO.Get_Line (String (s (w)), Integer (lens (w)));
      end loop;
      anag (s, lens, result);
      Ada.Text_IO.Put_Line (if result then "1" else "0");
      for w in two_t loop
         Ada.Text_IO.Put_Line (String (s (w)) (index_t'First..lens(w)));
      end loop;
   end run;

begin
   run;
end AsdAnagMain;
