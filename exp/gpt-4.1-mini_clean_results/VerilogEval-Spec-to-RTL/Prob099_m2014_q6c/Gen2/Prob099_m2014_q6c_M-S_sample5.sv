module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1: next state B (y[1]) = A and ~w
assign Y1 = y[0] & ~w;

// Y3: next state D (y[3]) = w and (B or C or E or F)
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule