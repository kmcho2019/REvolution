module TopModule (
    input [5:0] y,  // Current state (one-hot encoded)
    input w,        // Input signal
    output Y1,      // Next state y[1] (B)
    output Y2,      // Next state y[2] (C)
    output Y3,      // Next state y[3] (D)
    output Y4       // Next state y[4] (E)
);

    // State transition logic with complete outputs
    // Y1 (B) transitions: A->B when w=0
    assign Y1 = y[0] & ~w;

    // Y2 (C) transitions: B->C when w=0, F->C when w=0
    assign Y2 = (y[1] & ~w) | (y[5] & ~w);

    // Y3 (D) transitions: B->D, C->D, E->D, F->D (all when w=1)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

    // Y4 (E) transitions: C->E when w=0, E->E when w=0
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule