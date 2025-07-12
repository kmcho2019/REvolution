module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 represents next_state[1] (state B)
    // Active only when transitioning from A to B (y[0] & ~w)
    assign Y1 = y[0] & ~w;

    // Y3 represents next_state[3] (state D)
    // Active when:
    // - B->D (y[1] & w)
    // - C->D (y[2] & w)
    // - E->D (y[4] & w)
    // - F->D (y[5] & w)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule