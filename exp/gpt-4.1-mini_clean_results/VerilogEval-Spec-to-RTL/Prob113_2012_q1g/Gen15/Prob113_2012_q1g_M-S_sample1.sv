module TopModule(
    input  [3:0] x,
    output       f
);

    // Using x = {x3,x2,x1,x0}
    // Simplified expression:
    // f = (~x3 & ~x1) | (x2 & x1) | (x3 & ~x0) | (~x2 & ~x0)
    // Derived by grouping minterms and overlapping covers to minimize terms

    assign f = (~x[3] & ~x[1]) | (x[2] & x[1]) | (x[3] & ~x[0]) | (~x[2] & ~x[0]);

endmodule