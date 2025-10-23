module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1 represents next_state[1] (state B)
    assign Y1 = y[0] & ~w;

    // Y2 represents next_state[2] (state C)
    assign Y2 = (y[1] | y[5]) & ~w;

    // Y3 represents next_state[3] (state D)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

    // Y4 represents next_state[4] (state E)
    assign Y4 = y[2] & ~w;

endmodule