module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1 corresponds to state B, which can be reached from state A when w is '0'
    assign Y1 = ~w & y[0];

    // Y2 corresponds to state C, which can be reached from state B when w is '0' or from state A when w is '1'
    assign Y2 = w & y[0] | ~w & y[1];

    // Y3 corresponds to state D, which can be reached from states B, C, and E
    assign Y3 = w & (y[1] | y[2] | y[4]) | ~w & y[3];

    // Y4 corresponds to state E, which can be reached from state C when w is '1' or from state D when w is '0'
    assign Y4 = w & y[2] | ~w & y[3];

endmodule