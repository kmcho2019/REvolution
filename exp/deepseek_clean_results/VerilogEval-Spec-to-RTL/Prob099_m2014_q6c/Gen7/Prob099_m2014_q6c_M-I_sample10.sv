module TopModule(
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state D)
);

    // Y2 (next y[1]) is active when:
    // 1. In state A (y[0]) and w=0 (A→B)
    assign Y2 = y[0] & ~w;

    // Y4 (next y[3]) is active when:
    // 1. In state B (y[1]) and w=1 (B→D)
    // 2. In state C (y[2]) and w=1 (C→D)
    // 3. In state E (y[4]) and w=1 (E→D)
    // 4. In state F (y[5]) and w=1 (F→D)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule