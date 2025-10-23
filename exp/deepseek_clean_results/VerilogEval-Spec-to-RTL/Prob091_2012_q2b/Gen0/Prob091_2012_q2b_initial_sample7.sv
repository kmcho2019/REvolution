module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    assign Y1 = y[0] & w;  // Transition from A to B when w=1

    // Y3 is the next state for y[3] (state D)
    assign Y3 = (y[1] & ~w) |  // Transition from B to D when w=0
                (y[2] & ~w) |  // Transition from C to D when w=0
                (y[4] & ~w) |  // Transition from E to D when w=0
                (y[5] & ~w);   // Transition from F to D when w=0

endmodule