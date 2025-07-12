module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1 corresponds to state B, which can be reached from state A when w is '0' or from state D when w is '1'
    assign Y1 = (y[0] & ~w) | (y[3] & w) | (y[4] & w);

    // Y2 corresponds to state C, which can be reached from states B and F when w is '0'
    assign Y2 = (y[1] & ~w) | (y[5] & ~w);

    // Y3 corresponds to state D, which can be reached from states B, C, and E when w is '1'
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[3] & ~w);

    // Y4 corresponds to state F, which can be reached from states D when w is '0'
    assign Y4 = (y[3] & ~w);

endmodule