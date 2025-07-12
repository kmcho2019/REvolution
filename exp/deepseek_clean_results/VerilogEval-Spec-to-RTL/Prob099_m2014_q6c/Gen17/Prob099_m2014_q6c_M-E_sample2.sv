module TopModule (
    input [5:0] y,  // Current state (A=y[0], B=y[1],..., F=y[5])
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // State transition logic using explicit conditions
    // Y1 (next state B) = A->B transition (y[0] & ~w)
    assign Y1 = y[0] & ~w;

    // Y3 (next state D) = OR of all transitions to D:
    // B->D (y[1] & w)
    // C->D (y[2] & w)
    // E->D (y[4] & w)
    // F->D (y[5] & w)
    assign Y3 = (y[1] & w) |  // B->D
                (y[2] & w) |  // C->D
                (y[4] & w) |  // E->D
                (y[5] & w);   // F->D

endmodule