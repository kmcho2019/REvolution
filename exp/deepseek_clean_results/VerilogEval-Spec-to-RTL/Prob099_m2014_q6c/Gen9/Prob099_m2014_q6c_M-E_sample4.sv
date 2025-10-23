module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2 (next state B) comes from:
    // - A when w=0
    assign Y2 = y[0] & ~w;

    // Y4 (next state D) comes from:
    // - B when w=1
    // - C when w=1
    // - E when w=1
    // - F when w=1
    assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule