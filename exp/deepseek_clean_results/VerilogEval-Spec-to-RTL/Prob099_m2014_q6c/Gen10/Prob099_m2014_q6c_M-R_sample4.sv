module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Next state B (Y2) occurs only when in state A (y[0]) and w=0
    assign Y2 = ~w & y[0];

    // Next state D (Y4) occurs when:
    // - In state B (y[1]) and w=1, OR
    // - In state C (y[2]) and w=1, OR
    // - In state D (y[3]) and w=1, OR
    // - In state E (y[4]) and w=1, OR
    // - In state F (y[5]) and w=1
    assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule