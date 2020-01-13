package body AsdinveLib with
   SPARK_Mode
is
   function naive_result (A : arr) return Natural
   is
      t : Natural := 0;
   begin
      for i in A'Range loop
         for j in A'Range loop
            if i<j and A(i)>A(j) then
               t := t + 1;
            end if;
         end loop;
      end loop;
      return t;
   end naive_result;

   procedure insert_next(A : arr; S : in out sarr;
                         root, now : Positive;
                         t : out Natural)
   is
      tt : Natural := 0;
      c : LR;
   begin
      if A(now) < A(root) then
         tt := 1 + S(root).t;
         c := Left;
      else
         S(root).t := S(root).t + 1;
         c := Right;
      end if;
      if S(root).c(c) /= 0 then
         declare
            pt : Natural;
         begin
            insert_next(A, S, S(root).c(c), now, pt);
            t := tt + pt;
         end;
      else
         S(root).c(c) := now;
         t := tt;
      end if;
   end insert_next;

   procedure trec_result (A : arr; S : in out sarr;
                          r : Positive; t : out Natural)
   is
      tt, pt : Natural;
   begin
      insert_next(A, S, A'First, r, tt);
      trec_result(A, S, r+1, pt);
      tt := tt + pt;
      t := tt;
   end trec_result;

   function result (A : arr) return Natural
   is
      r : sarr (A'Range) := (others => s'(t => 0, c => (0, 0)));
      t : Natural;
   begin
      trec_result(A, r, A'First, t);
      return t;
   end result;

end AsdinveLib;
