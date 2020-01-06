with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
procedure Asdanag is

   subtype char is Character;
   type index_t is range 1 .. 10000;
   type two_t is range 1 .. 2;
   type wordstore is array (index_t) of char;

   s : array (two_t) of wordstore;
   n : array (two_t) of index_t;
   c : index_t;

   procedure swap (w : two_t; f, t : index_t) is
      tcc : char;
   begin
      tcc       := s (w) (t);
      s (w) (t) := s (w) (f);
      s (w) (f) := tcc;
   end swap;

   procedure heapify (w : two_t) is
      i  : index_t;
      nc : index_t;
   begin
      loop
         i := c * 2 + 1;
         loop
            nc := c;
            if i < n (w) and s (w) (i) > s (w) (nc) then
               nc := i;
            end if;
            exit when i mod 2 /= 0;
            i := i + 1;
         end loop;
         exit when c = nc;
         swap (w, c, nc);
         c := nc;
      end loop;
   end heapify;

   lens : array (two_t) of index_t;

   procedure sort (w : two_t) is
   begin
      n (w) := lens (w);
      c     := lens (w) / 2;
      while c >= 1 loop
         heapify (w);
      end loop;
      n (w) := n (w) - 1;
      while n (w) >= 1 loop
         swap (w, 1, n (w));
         c := 1;
         heapify (w);
      end loop;
   end sort;

   function anag return Boolean is
   begin
      if lens (1) /= lens (2) then
         return False;
      end if;
      sort (1);
      sort (2);
      for c in 0 .. (lens (1) - 1) loop
         if s (1) (c) /= s (2) (c) then
            return False;
         end if;
      end loop;
      return True;
   end anag;

   InputTooLarge : exception;

   procedure scans (w : two_t) is
      fin : Boolean := False;
      i   : index_t := 1;
   begin
      charseq:
      loop
         if i = index_t'Last then
            raise InputTooLarge with Standard.String(s(w));
         end if;
         declare
            c : Character;
         begin
            if i = 1 then
               loop
                  Ada.Text_IO.Get_Immediate(c);
                  exit when c /= Ada.Characters.Latin_1.LF;
               end loop;
            end if;
            fin := fin or (c = Ada.Characters.Latin_1.LF);
            exit charseq when fin;
            s (w) (i) := c;
            i         := i + 1;
         exception
            when Ada.Text_IO.End_Error =>
               if i = 1 then
                  raise;
               else
                  fin := True;
               end if;
         end;
         exit when fin;
      end loop charseq;
      returning :
      begin
         lens (w) := i - 1;
      end returning;
   end scans;

begin
   Ada.Text_IO.Put_Line("hejtest");
   for i in two_t loop
      scans (i);
   end loop;
   Ada.Text_IO.Put (if anag then '1' else '0');
   Ada.Text_IO.Put (Ada.Characters.Latin_1.LF);
end Asdanag;
