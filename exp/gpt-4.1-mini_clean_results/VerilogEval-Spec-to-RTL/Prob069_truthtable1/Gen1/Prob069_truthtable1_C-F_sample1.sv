module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // From the truth table:
    // f=1 for inputs: 010, 011, 101, 111
    // Corresponding minterms:
    //   !x3 &  x2 & !x1
    //   !x3 &  x2 &  x1
    //    x3 & !x2 &  x1
    //    x3 &  x2 &  x1
    //
    // Simplified expression:
    // f = (~x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);

endmodule