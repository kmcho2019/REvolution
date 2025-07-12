module TopModule(
    input [5:0] y,  // Current state (one-hot encoded)
    input w,        // Input signal
    output Y1,      // Next state A (y[0])
    output Y3       // Next state D (y[3])
);

    // Internal signals for all possible next states
    wire next_A, next_B, next_C, next_D, next_E, next_F;

    // Next state logic - centralized computation
    assign next_A = (y[0] & w) | (y[3] & w);
    assign next_B = y[0] & ~w;
    assign next_C = (y[1] & ~w) | (y[5] & ~w);
    assign next_D = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);
    assign next_E = (y[2] & ~w) | (y[4] & ~w);
    assign next_F = y[3] & ~w;

    // Only expose the required outputs
    assign Y1 = next_A;
    assign Y3 = next_D;

endmodule