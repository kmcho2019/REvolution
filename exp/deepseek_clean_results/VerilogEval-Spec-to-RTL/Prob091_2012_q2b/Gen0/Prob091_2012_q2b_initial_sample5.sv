module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    // B can only be reached from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D)
    // D can be reached from B, C, E, or F when w=0
    // or from D when w=0 (but one-hot ensures only one state is active)
    assign Y3 = (y[1] & ~w) |  // From B
                (y[2] & ~w) |  // From C
                (y[4] & ~w) |  // From E
                (y[5] & ~w);   // From F

endmodule