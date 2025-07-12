module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Next state B (Y1) occurs only when:
    // - Currently in state A (y[0]) AND input is 0
    assign Y1 = y[0] & ~w;

    // Next state D (Y3) occurs when:
    wire from_B = y[1] & w;    // From B with w=1
    wire from_C = y[2] & w;    // From C with w=1
    wire stay_D = y[3] & ~w;   // Stay in D with w=0
    wire from_E = y[4] & w;    // From E with w=1
    wire from_F = y[5] & w;    // From F with w=1

    // Combine all possible transitions to state D
    assign Y3 = from_B | from_C | stay_D | from_E | from_F;

endmodule