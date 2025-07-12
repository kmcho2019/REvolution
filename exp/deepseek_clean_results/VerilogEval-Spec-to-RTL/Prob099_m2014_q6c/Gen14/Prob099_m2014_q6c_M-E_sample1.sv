module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next y[0] (state A)
    output Y3      // Next y[3] (state D)
);

    // State assignments (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Y1 is next y[0] (state A)
    assign Y1 = (y[0] & w) |  // Stay in A if w=1
                (y[3] & w);    // D->A if w=1

    // Y3 is next y[3] (state D)
    assign Y3 = (y[1] & w) |  // B->D if w=1
                (y[2] & w) |   // C->D if w=1
                (y[3] & ~w) | // D->F if w=0 (but F's y[5] isn't our concern)
                (y[4] & w) |   // E->D if w=1
                (y[5] & w);    // F->D if w=1

endmodule