module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state B (y[1]) is active if current state is A (y[0]) and w=0
    assign Y1 = y[0] & ~w;

    // Next state D (y[3]) is active if w=1 and current state is B, C, E or F
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule