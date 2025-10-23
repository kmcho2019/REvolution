module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2 (next state B) only comes from state A (y[0]) when w=0
    assign Y2 = y[0] & ~w;

    // Y4 (next state D) comes from:
    // State B (y[1]) when w=1 OR
    // State C (y[2]) when w=1 OR
    // State E (y[4]) when w=1 OR
    // State F (y[5]) when w=1
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule