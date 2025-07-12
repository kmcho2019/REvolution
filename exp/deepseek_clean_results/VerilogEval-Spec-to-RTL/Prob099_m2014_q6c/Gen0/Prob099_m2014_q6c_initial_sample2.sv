module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is set when in state A (y[0]) and w is 0
    assign Y1 = y[0] & ~w;

    // Y3 is set when in states B, C, E, or F and w is 1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule