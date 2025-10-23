module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2 (next state B) comes from state A when w=0
    assign Y2 = y[0] & ~w;

    // Y4 (next state D) comes from multiple states when w=1
    // States: B, C, D, E, F (y[1], y[2], y[3], y[4], y[5])
    assign Y4 = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;

endmodule