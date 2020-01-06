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
   procedure anag (s : in out s_t; lens : in lens_t; result : out Boolean);
end AsdanagLib;
