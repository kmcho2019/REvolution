module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state B (y[1]) is active if current state A (y[0]) and w=0
    assign Y1 = y[0] & ~w;

    // Next state D (y[3]) is active if current state is B, C, E or F and w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule