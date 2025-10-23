module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next y[1] (state B)
    output Y4      // Next y[3] (state D)
);

    // State assignments (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Y2 is next y[1] (state B) - only occurs from A with w=0
    assign Y2 = y[0] & ~w;

    // Y4 is next y[3] (state D)
    assign Y4 = (y[1] & w) |  // B->D if w=1
                (y[2] & w) |   // C->D if w=1
                (y[4] & w) |   // E->D if w=1
                (y[5] & w);    // F->D if w=1

endmodule