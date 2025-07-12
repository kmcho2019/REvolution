module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state for y[0] (state A)
    output Y3      // Next state for y[2] (state C)
);

    // State assignments (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Next state logic for Y1 (next state for y[0] - state A)
    assign Y1 = (y[0] & w) |       // Stay in A if w=1
                (y[3] & w);         // Transition to A from D if w=1

    // Next state logic for Y3 (next state for y[2] - state C)
    assign Y3 = (y[1] & ~w) |       // Transition to C from B if w=0
                (y[5] & ~w);        // Transition to C from F if w=0

endmodule