module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Next-state logic for Y2 (corresponding to state B, y[1])
    assign Y2 = (y[0] & ~w) | (y[5] & w);

    // Next-state logic for Y4 (corresponding to state D, y[3])
    assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[3] & ~w);

    // Since the problem statement asks for Y1 and Y3 as outputs but doesn't specify their logic,
    // we can simply assign them to the current state's corresponding bits for simplicity.
    assign Y1 = y[0];
    assign Y3 = y[2];

endmodule