module TopModule(
    input  [3:0] x, // x[3]=x[4], x[2]=x[3], x[1]=x[2], x[0]=x[1]
    output       f
);

    // Define convenient aliases for clarity:
    wire x1 = x[0]; // x[1]
    wire x2 = x[1]; // x[2]
    wire x3 = x[2]; // x[3]
    wire x4 = x[3]; // x[4]

    /*
    Karnaugh map summary (rows = x4 x3, columns = x1 x2):

         x1x2
    x4x3  00 01 11 10
    00   d   0  d  d
    01   0   d  1  0
    11   1   1  d  d
    10   1   1  0  d

    Choosing don't-cares = 0 where convenient.

    Analyzing the '1' minterms:

    1) Row 10 (x4=1, x3=0), Col 00 and 01 => (x4 & ~x3 & ~x2) & (~x2 & ~x1 or ~x2 & x1)
       Simplifies to x4 & ~x3 & ~x2 (since col=00 and 01 only differ in x1)
    2) Row 11 (x4=1, x3=1), Col 00 and 01 => x4 & x3 & ~x2
    3) Row 01 (x4=0, x3=1), Col 11 => ~x4 & x3 & x2 & x1
    4) Row 11 (x4=1, x3=1), Col 01 => x4 & x3 & ~x2 & x1

    Combining:

    f = (x4 & ~x3 & ~x2)           // minterm at 10-00 and 10-01 (covers both 00 and 01 columns)
      | (x4 & x3 & ~x2)            // minterm at 11-00 and 11-01 (covers both 00 and 01 columns)
      | (~x4 & x3 & x2 & x1)       // minterm at 01-11
      | (x4 & x3 & ~x2 & x1);      // minterm at 11-01 more specifically including x1

    Note that the last term is a subset of second term, so combine carefully:

    Actually, minterms from Karnaugh map are:
      - For 10-00 and 10-01: x4=1, x3=0, x2=0, x1=don't care → x4 & ~x3 & ~x2
      - For 11-00 and 11-01: x4=1, x3=1, x2=0, x1=don't care (except one minterm 11-01 also has f=1)
        So x4 & x3 & ~x2

      - For 01-11: x4=0, x3=1, x2=1, x1=1 → ~x4 & x3 & x2 & x1

    So final minimized expression:

    f = (x4 & ~x3 & ~x2) | (x4 & x3 & ~x2) | (~x4 & x3 & x2 & x1);

    Implementing this:

    */

    assign f = (x4 & ~x3 & ~x2) | (x4 & x3 & ~x2) | (~x4 & x3 & x2 & x1);

endmodule