module TopModule(
    input [5:0] y,  // One-hot encoded state
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state D)
);

    // Y2 is active only when in state A (y[0]) and w=0 (A→B)
    assign Y2 = y[0] & ~w;

    // Y4 is active when transitioning to D from:
    // B (y[1] & w), C (y[2] & w), E (y[4] & w), or F (y[5] & w)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule