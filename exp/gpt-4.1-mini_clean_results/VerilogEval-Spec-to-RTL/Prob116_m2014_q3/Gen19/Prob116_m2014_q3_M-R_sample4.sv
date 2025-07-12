module TopModule (
    input  [3:0] x,   // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (problem order)
    output      f
);

    // Rename bits for clarity according to problem statement
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From the Karnaugh map, derive minimal Boolean expression for f:
    // After analysis (considering the given minterms and don't-cares):
    // f = (x4 & ~x3)                      // covers row 10 cols 00,01
    //   | (x3 & x4 & ~x2 & ~x1)          // covers row 11 col 10 (d->0) so exclude
    //   | (x3 & x4 & x2)                 // covers row 11 cols 01 (1), 11(d), 10(d)
    //   | (~x4 & x3)                     // covers row 01 cols 11(1),10(0) so careful
    // After checking carefully the 1-cells:
    // Minterms (in binary x4 x3 x2 x1):
    // 0111 (x4=0 x3=1 x2=1 x1=1) = 1
    // 1100 (1 1 0 0) =1
    // 1101 (1 1 0 1) =1
    // 1000 (1 0 0 0) =1
    // 1001 (1 0 0 1) =1
    // 1110 (1 1 1 0) = d->0 chosen
    // So we can simplify:
    // Group 1: x4 & ~x3   => covers 1000,1001 (row 10 col 00,01)
    // Group 2: x3 & x4 & ~x1  covers 1100,1101
    // Group 3: x3 & ~x4 & x2 & x1 covers 0111
    // Group 4: x3 & x4 & ~x2 & ? no 1 here
    // Checking only actual 1's:
    // Final expression:
    // f = (x4 & ~x3)                // covers 1000,1001
    //   | (x3 & x4 & ~x1)           // covers 1100,1101
    //   | (~x4 & x3 & x2 & x1);     // covers 0111

    assign f = (x4 & ~x3) | (x3 & x4 & ~x1) | (~x4 & x3 & x2 & x1);

endmodule