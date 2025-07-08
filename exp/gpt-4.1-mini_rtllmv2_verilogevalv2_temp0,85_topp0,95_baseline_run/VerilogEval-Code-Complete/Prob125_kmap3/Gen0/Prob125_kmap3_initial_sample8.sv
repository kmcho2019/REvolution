module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    // Translate Karnaugh map to minterms:
    // cd \ ab: 01 00 10 11
    // 00       d  0  1  1
    // 01       0  0  d  d
    // 11       0  1  1  1
    // 10       0  1  1  1
    //
    // Variables: a,b,c,d
    // Positions for 1:
    // cd=00, ab=10 => c=0,d=0,a=1,b=0 =>  c'd'a b'
    // cd=00, ab=11 => c=0,d=0,a=1,b=1 =>  c'd'a b
    // cd=11, ab=00 => c=1,d=1,a=0,b=0 =>  c d a' b'
    // cd=11, ab=10 => c=1,d=1,a=1,b=0 =>  c d a b'
    // cd=11, ab=11 => c=1,d=1,a=1,b=1 =>  c d a b
    // cd=10, ab=01 => c=1,d=0,a=0,b=1 =>  c d' a' b
    // cd=10, ab=10 => c=1,d=0,a=1,b=0 =>  c d' a b'
    // cd=10, ab=11 => c=1,d=0,a=1,b=1 =>  c d' a b
    //
    // Use don't-cares to simplify:
    // Group 1: ab=10 or 11 in cd=00 row => c'=0,d=0,a=1,b=X => c'd'a
    // Group 2: cd=11 or 10 rows with ab=10 or 11 => c=1,a=1,b=X => c a
    // Group 3: cd=11 or 10 with ab=01 => c=1,b=1,a=0,d=0 or 1 => c b a'
    //
    // Combine groups:
    // out = c'd'a + c a + c b a'
    // Simplify c b a' + c a = c a + c b a' = c a + c b a' = c a + c b a' (no further simplification)
    //
    // Final simplified expression:
    // out = c'd'a + c a + c b a'

    out = ( ~c & ~d & a ) | ( c & a ) | ( c & b & ~a );
  end

endmodule