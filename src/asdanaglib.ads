with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
package AsdanagLib with
SPARK_Mode
is
   subtype char is Character;
   subtype index_t is Positive range 1 .. 10000;
   type wordstore is array (index_t) of char;
   subtype two_t is Integer range 1 .. 2;
   type s_t is array (two_t) of wordstore;
   type lens_t is array (two_t) of index_t;
   function heap_property (s : wordstore; ending, f : index_t)
                           return Boolean with Ghost,
     Pre => f <= ending;
   function children_valid_heaps (s : wordstore; ending, f : index_t)
                                  return Boolean with Ghost,
     Pre => f <= ending;
   procedure anag (s : in out s_t; lens : in lens_t; result : out Boolean) with
     Pre => (for all W in two_t'Range =>
               (for all I in index_t'First .. lens(W) =>
                    s(W)(I) in 'a'..'z'));
   procedure swap (s : in out wordstore; f, t : index_t);
   FurthestParentStatic : constant index_t :=
     index_t'Last / 2 + ((index_t'Last rem 2) + index_t'First - 1) / 2;
   subtype parent_t is index_t range (index_t'First) .. FurthestParentStatic;
   function furthestParent (ending : in index_t) return parent_t with
     Pre => ending /= index_t'First,
     Post => furthestParent'Result < ending and
       leftChild(furthestParent'Result) <= ending;
   function leftChild (parent : in parent_t) return index_t with
     Post => leftChild'Result > parent;
   procedure siftDown (s : in out wordstore; ending, f : in index_t) with
     Pre => f <= ending and children_valid_heaps(s, ending, f),
     Post => heap_property(s, ending, f);
   procedure heapify (s : in out wordstore; ending : in index_t);
   procedure sort(s : in out wordstore; ending : in index_t) with
     Pre => (for all I in index_t'First .. ending =>
            s(I) in 'a'..'z'),
     Post => (for all I in index_t'Succ(index_t'First) .. ending =>
                (s(I-1) <= s(I)));
end AsdanagLib;
