module TopModule (
    input  [3:0] x,  // x = {x4, x3, x2, x1}
    output      f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From K-map minimization (don't-cares chosen for simplification),
    // the simplified boolean expression for f is:
    //
    // f = x3 & x4
    //   | x4 & (~x3) & ~x2
    //   | x3 & (~x4) & x2
    //   | (~x4) & (~x3) & x2 & ~x1
    //
    // This expression covers all '1's and valid don't-cares.
    assign f = (x3 & x4)
             | (x4 & ~x3 & ~x2)
             | (x3 & ~x4 & x2)
             | (~x4 & ~x3 & x2 & ~x1);

endmodule