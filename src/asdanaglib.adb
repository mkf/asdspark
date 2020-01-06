with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
package body AsdanagLib with
   SPARK_Mode
is
   procedure swap (s : in out wordstore; f, t : index_t) is
      tcc : char := s (t);
   begin
      s (t) := s (f);
      s (f) := tcc;
   end swap;

   FirstChild : constant index_t := index_t'First + 1;

   FurthestParentStatic : constant index_t :=
     index_t'Last / 2 + ((index_t'Last rem 2) + index_t'First - 1) / 2;

   subtype parent_t is index_t range (index_t'First) .. FurthestParentStatic;

   function furthestParent (ending : in index_t) return parent_t is
   begin
      return Integer (ending / 2) +
        (Integer (ending rem 2) + Integer (index_t'First) - 1) / 2;
   end furthestParent;

   function leftChild (parent : in parent_t) return index_t is
   begin
      return 2 * parent + 1 - index_t'First;
   end leftChild;

   procedure siftDown (s : in out wordstore; ending, f : in index_t) is
      t      : index_t := f;
      i      : index_t;
      j      : index_t;
      furPar : parent_t;
   begin
      if ending /= f then
         furPar := furthestParent (ending);
         while t <= furPar loop
            pragma Loop_Variant (Increases => t);
            i := leftChild (t);
            j := t;
            if s (j) < s (i) then
               j := i;
            end if;
            if i /= index_t'Last and then s (j) < s (i + 1) then
               j := i + 1;
            end if;
            exit when j = t;
            swap (s, t, j);
            t := j;
         end loop;
      end if;
   end siftDown;

   procedure heapify (s : in out wordstore; ending : in index_t) is
      furPar : parent_t;
   begin
      if ending /= index_t'First then
         furPar := furthestParent (ending);
         for i in reverse parent_t'First .. furPar loop
            siftDown (s, ending, i);
         end loop;
      end if;
   end heapify;

   procedure sort (s : in out wordstore; ending : in index_t) is
      heapEnding : index_t := ending;
   begin
      heapify (s, ending);
      heapEnding := heapEnding - 1;
      while heapEnding > index_t'First loop
         swap (s, heapEnding, index_t'First);
         heapEnding := heapEnding - 1;
         siftDown (s, heapEnding, index_t'First);
      end loop;
   end sort;

   procedure anag (s : in out s_t; lens : in lens_t; result : out Boolean)
   is
   begin
      if lens (1) /= lens (2) then
         result := False;
         return;
      end if;
      if lens (1) /= index_t'First then
         for i in two_t loop
            sort (s (i), lens (i));
            -- Ada.Text_IO.Put_Line(String(s(i))(index_t'First..lens(i)));
         end loop;
      end if;
      for c in index_t'First .. (lens (1)) loop
         if s (1) (c) /= s (2) (c) then
            result := False;
            return;
         end if;
      end loop;
      result := True;
      return;
   end anag;
end AsdanagLib;
