module TopModule(
    input [5:0] y,  // Current state (one-hot encoded)
    input w,        // Input signal
    output Y1,      // Next state A (y[0] will be set)
    output Y2,      // Next state C (y[2] will be set)
    output Y3,      // Next state D (y[3] will be set)
    output Y4       // Next state E (y[4] will be set)
);

    // Y1 is set when:
    // 1. In state A (y[0]) and w=1 (stays in A)
    // 2. In state D (y[3]) and w=1 (transitions to A)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y2 is set when:
    // 1. In state B (y[1]) and w=0 (goes to C)
    // 2. In state F (y[5]) and w=0 (goes to C)
    assign Y2 = (y[1] & ~w) | (y[5] & ~w);

    // Y3 is set when:
    // 1. In state B (y[1]) and w=1 (goes to D)
    // 2. In state C (y[2]) and w=1 (goes to D)
    // 3. In state E (y[4]) and w=1 (goes to D)
    // 4. In state F (y[5]) and w=1 (goes to D)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

    // Y4 is set when:
    // 1. In state C (y[2]) and w=0 (goes to E)
    // 2. In state E (y[4]) and w=0 (stays in E)
    assign Y4 = (y[2] & ~w) | (y[4] & ~w);

endmodule