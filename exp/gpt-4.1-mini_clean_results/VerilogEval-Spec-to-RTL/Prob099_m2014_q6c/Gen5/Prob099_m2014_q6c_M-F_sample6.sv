module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

    // Next state B (y[1]) = A and ~w
    assign Y2 = y[0] & ~w;

    // Next state D (y[3]) = w and (B or C or E or F)
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule