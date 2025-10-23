module TopModule(
    input [5:0] y,    // Current state (one-hot encoded)
    input w,          // Input
    output Y1, Y2, Y3, Y4  // Next state bits (y[1]-y[4])
);

    // Y1 (next y[1]): Activated when transitioning to state B (y[1])
    // Only transition: A->B when w=0
    assign Y1 = y[0] & ~w;

    // Y2 (next y[2]): Activated when transitioning to state C (y[2])
    // Transitions: B->C when w=0, F->C when w=0
    assign Y2 = (y[1] & ~w) | (y[5] & ~w);

    // Y3 (next y[3]): Activated when transitioning to state D (y[3])
    // Transitions: B->D when w=1, C->D when w=1, E->D when w=1, F->D when w=1
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

    // Y4 (next y[4]): Activated when transitioning to state E (y[4])
    // Only transition: C->E when w=0
    assign Y4 = y[2] & ~w;

endmodule