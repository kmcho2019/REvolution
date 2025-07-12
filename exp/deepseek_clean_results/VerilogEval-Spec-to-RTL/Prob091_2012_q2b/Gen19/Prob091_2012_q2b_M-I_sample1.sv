module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // Input signal
    output Y1,        // Next state for y[1] (state B)
    output Y3         // Next state for y[3] (state D)
);

    // State encoding (one-hot):
    // y[0] = 000001 = A
    // y[1] = 000010 = B
    // y[2] = 000100 = C
    // y[3] = 001000 = D
    // y[4] = 010000 = E
    // y[5] = 100000 = F

    // Y1: Next state for y[1] (state B)
    // Only transitions from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions when:
    // 1. Not in A (y[0]) or D (y[3])
    // 2. w=0
    // Implemented as single NOR operation
    assign Y3 = ~w & ~y[0] & ~y[3];

endmodule