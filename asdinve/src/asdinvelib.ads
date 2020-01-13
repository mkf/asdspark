package AsdinveLib with
SPARK_Mode
is
   type arr is array (Positive range <>) of Positive;
   function naive_result(A : arr) return Natural with
     Ghost,
     Pre => (A'Length <= 10000) and
     (for all I in A'Range =>
        (for all J in A'Range => (I=J or A(I)/=A(J))));
   subtype w_t is Positive;
   type LR is (Left, Right);

   type s;
   type slrarr is array (LR) of Natural;
   type s is record
      t : Natural := 0;
      c : slrarr := (0, 0);
   end record;

   type sarr is array (Positive range <>) of s;
   procedure insert_next(A : arr; S : in out sarr;
                         root, now : Positive;
                         t : out Natural) with
     Pre => (root in S'Range) and (now in S'Range) and
     (A'First = S'First) and (A'Last = S'Last) and (A'First = 1) and
     (for all I in S'Range => (S(I).t<=((A'Length * (A'Length-1))/2))),
     Post => t<=((A'Length * (A'Length-1))/2);
   procedure trec_result(A : arr; S : in out sarr;
                         r : Positive; t : out Natural) with
     Pre => (r in S'Range) and (A'First = S'First) and
     (A'Last = S'Last) and (A'First = 1) and
     (for all I in S'Range => (S(I).t<=((A'Length * (A'Length-1))/2))),
     Post => t<=((A'Length * (A'Length-1))/2);
   function result(A : arr) return Natural with
     Pre => (A'First = 1),
     Post => (result'Result = naive_result(A)) and
     (result'Result <= ((A'Length * (A'Length-1))/2));
end AsdinveLib;
