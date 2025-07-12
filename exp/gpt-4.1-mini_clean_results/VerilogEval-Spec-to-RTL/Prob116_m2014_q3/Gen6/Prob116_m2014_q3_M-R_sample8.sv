module TopModule(
    input  [3:0] x,
    output      f
);

    // Inputs for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Karnaugh map given (rows = x3 x2, columns = x1 x0):
    //
    // x3 x2 \ x1 x0 | 00 | 01 | 11 | 10
    // --------------|----|----|----|----
    // 00           |  d |  0 |  d |  d
    // 01           |  0 |  d |  1 |  0
    // 11           |  1 |  1 |  d |  d
    // 10           |  1 |  1 |  0 |  d
    //
    // We'll write the minterms for f=1:

    // Row 01 (x3=0, x2=1):
    // col 11 (x1=1, x0=1): f=1 at x=0 1 1 1
    // Row 11 (x3=1, x2=1):
    // col 00 (x1=0, x0=0): f=1 at x=1 1 0 0
    // col 01 (x1=0, x0=1): f=1 at x=1 1 0 1
    // Row 10 (x3=1, x2=0):
    // col 00 (x1=0, x0=0): f=1 at x=1 0 0 0
    // col 01 (x1=0, x0=1): f=1 at x=1 0 0 1

    // Express f as sum of these minterms:
    // m1: ~x3 & x2 & x1 & x0        (for 0111)
    // m2: x3 & x2 & ~x1 & ~x0      (for 1100)
    // m3: x3 & x2 & ~x1 & x0       (for 1101)
    // m4: x3 & ~x2 & ~x1 & ~x0     (for 1000)
    // m5: x3 & ~x2 & ~x1 & x0      (for 1001)

    // Combine terms to simplify if possible.

    assign f = 
          (~x3 &  x2 &  x1 &  x0)        // m1
        | ( x3 &  x2 & ~x1 & ~x0)        // m2
        | ( x3 &  x2 & ~x1 &  x0)        // m3
        | ( x3 & ~x2 & ~x1 & ~x0)        // m4
        | ( x3 & ~x2 & ~x1 &  x0);       // m5

endmodule