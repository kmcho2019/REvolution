module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    wire p1_and;
    wire p2_and;

    // Perform 4-input AND for the first gate
    assign p1_and = p1a & p1b & p1c & p1d;
    // NAND output is negation of the AND result
    assign p1y = ~p1_and;

    // Perform 4-input AND for the second gate
    assign p2_and = p2a & p2b & p2c & p2d;
    // NAND output is negation of the AND result
    assign p2y = ~p2_and;

endmodule