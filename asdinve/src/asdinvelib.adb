package body AsdinveLib with
   SPARK_Mode
is
   subtype w_t is Positive;
   type LR is (Left, Right);

   type s;
   type slrarr is array (LR) of access s;
   type s is record
      w : w_t;
      t : Natural := 0;
      c : slrarr := (null, null);
   end record;

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

   function result (A : arr) return Natural
   is
      t : Natural := 0;
      r : access s := null;
      p, q : access s;
      c : LR;
   begin
      for u in A'Range loop
         p := new s'(w => A(u), t => 0, c => (null, null));
         if r = null then
            r := p;
         else
            q := r;
            loop
               if p.w < q.w then
                  t := t + 1 + q.t;
                  c := Left;
               else
                  q.t := q.t + 1;
                  c := Right;
               end if;
               if q.c(c) /= null then
                  q := q.c(c);
               else
                  q.c(c) := p;
                  exit;
               end if;
            end loop;
         end if;
      end loop;
      return t;
   end result;

end AsdinveLib;
