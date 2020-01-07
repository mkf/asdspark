with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
package body AsdanagLib with
   SPARK_Mode
is

   procedure assume_char_lowerenglish (a : char) is
   begin
      pragma Assume (a in 'a'..'z');
   end;

   procedure assume_word_lowerenglish (s : wordstore; ending : index_t) is
   begin
      for i in index_t'First .. ending loop
         assume_char_lowerenglish(s(i));
      end loop;
   end assume_word_lowerenglish;

   procedure swap (s : in out wordstore; f, t : index_t) is
      tcc : char := s (t);
   begin
      s (t) := s (f);
      s (f) := tcc;
   end swap;

   FirstChild : constant index_t := index_t'First + 1;

   function furthestParent (ending : in index_t) return parent_t is
   begin
      return Integer (ending / 2) +
        (Integer (ending rem 2) + Integer (index_t'First) - 1) / 2;
   end furthestParent;

   function leftChild (parent : in parent_t) return index_t is
   begin
      return 2 * parent + 1 - index_t'First;
   end leftChild;

   function heap_property (s : in wordstore; ending, f : in index_t)
     return Boolean
   is
      t : index_t := f;
      i : index_t;
      furPar : parent_t;
   begin
      if ending /= f then
         furPar := furthestParent(ending);
         while t <= furPar loop
            i := leftChild (t);
            if s(t) < s(i) then
               return False;
            end if;
            if i < ending and then s (t) < s (i + 1) then
               return False;
            end if;
            t := index_t'Succ(t);
         end loop;
         return True;
      else
         return True;
      end if;
   end heap_property;

   function children_valid_heaps (s : in wordstore; ending, f : in index_t)
                                  return Boolean
   is
      i : index_t;
      furPar : parent_t;
   begin
      if ending /= f then
         pragma Assert (f < ending);
         furPar := furthestParent(ending);
         if f <= furPar then
            i := leftChild(f);
            pragma Assert (i <= ending);
            if not heap_property(s, ending, i) then
               return False;
            end if;
            if i < ending then
               return heap_property(s, ending, index_t'Succ(i));
            end if;
         end if;
      end if;
      return True;
   end children_valid_heaps;

   procedure siftDown (s : in out wordstore; ending, f : in index_t) is
      t      : index_t := f;
      i      : index_t;
      j      : index_t;
      furPar : parent_t;
   begin
      if ending /= f then
         furPar := furthestParent (ending);
         theLoop:
         while t <= furPar loop
            pragma Loop_Variant (Increases => t);
            pragma Loop_Invariant (children_valid_heaps(s, ending, t));
            assume_word_lowerenglish(s, ending);
            i := leftChild (t);
            j := t;
            if s (j) < s (i) then
               j := i;
            end if;
            if i < ending and then s (j) < s (i + 1) then
               j := i + 1;
            end if;
            if j = t then
               t := ending; -- should be ghost code
               exit theLoop;
            end if;
            swap (s, t, j);
            t := j;
         end loop theLoop;
      end if;
   end siftDown;

   procedure heapify (s : in out wordstore; ending : in index_t) is
      furPar : parent_t;
   begin
      if ending /= index_t'First then
         furPar := furthestParent (ending);
         assume_word_lowerenglish(s, ending);
         for i in reverse parent_t'First .. furPar loop
            siftDown (s, ending, i);
         end loop;
      end if;
   end heapify;

   procedure sort (s : in out wordstore; ending : in index_t) is
      heapEnding : index_t := ending;
   begin
      if ending /= index_t'First then
         heapify (s, ending);
         heapEnding := heapEnding - 1;
         while heapEnding > index_t'First loop
            swap (s, heapEnding, index_t'First);
            heapEnding := heapEnding - 1;
            siftDown (s, heapEnding, index_t'First);
         end loop;
      end if;
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
