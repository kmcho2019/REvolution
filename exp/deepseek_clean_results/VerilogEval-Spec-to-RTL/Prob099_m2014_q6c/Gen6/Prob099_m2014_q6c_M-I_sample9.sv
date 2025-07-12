module TopModule(
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,        // Input signal
    output Y1,      // Next state y[0] (state A)
    output Y3       // Next state y[2] (state C)
);

    // Y1 (next y[0]) is active when:
    // 1. In state D (y[3]) and w=1 (D→A)
    // 2. In state A (y[0]) and w=1 (A→A)
    assign Y1 = (y[3] & w) | (y[0] & w);

    // Y3 (next y[2]) is active when:
    // 1. In state B (y[1]) and w=0 (B→C)
    // 2. In state F (y[5]) and w=0 (F→C)
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule