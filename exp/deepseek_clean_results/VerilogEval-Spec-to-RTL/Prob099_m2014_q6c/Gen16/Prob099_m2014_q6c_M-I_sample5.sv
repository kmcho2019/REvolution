module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (state B)
    output Y4      // Next state y[3] (state D)
);

    // Next state logic for Y2 (y[1] - state B)
    assign Y2 = y[0] & ~w;  // Only from state A when w=0

    // Next state logic for Y4 (y[3] - state D)
    assign Y4 = (y[0] & ~w) |  // A->B->D path
                (|y[5:1] & w);  // From any other state when w=1

endmodule