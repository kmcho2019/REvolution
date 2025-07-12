module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 corresponds to state B, which can be reached from state A when w is '0'
    assign Y1 = ~w & y[0];

    // Y3 corresponds to state D, which can be reached from states B, C, and E
    assign Y3 = w & (y[1] | y[2] | y[4]) | ~w & y[4];

endmodule