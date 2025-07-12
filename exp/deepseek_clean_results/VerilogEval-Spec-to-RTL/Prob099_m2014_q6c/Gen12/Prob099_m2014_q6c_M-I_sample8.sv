module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (E)
);

    // Y2 (next state B) comes from:
    // - Current state A (y[0]) when w=0
    assign Y2 = y[0] & ~w;

    // Y4 (next state E) comes from:
    // - Current state C (y[2]) when w=0
    assign Y4 = y[2] & ~w;

endmodule