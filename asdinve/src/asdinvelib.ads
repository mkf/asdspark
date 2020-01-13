package AsdinveLib with
SPARK_Mode
is
   type arr is array (Positive range <>) of Positive;
   function naive_result(A : arr) return Natural with Ghost;
   function result(A : arr) return Natural with
      Post => result'Result = naive_result(A);
end AsdinveLib;
