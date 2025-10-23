module TopModule (
    input [5:0] y,    // One-hot encoded state: y[5:0] = FEDCBA
    input w,          // State machine input
    output Y1,        // Next state for y[1] (B) - from A when w=1
    output Y3         // Next state for y[3] (D) - from B/C/F when w=0
);

    // State encoding (one-hot):
    // y[0] = 000001 = A
    // y[1] = 000010 = B
    // y[2] = 000100 = C
    // y[3] = 001000 = D
    // y[4] = 010000 = E
    // y[5] = 100000 = F

    // Y1 logic: Transition to B (y[1]) occurs only from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Improved Y3 logic: Transition to D (y[3]) occurs when:
    // 1. Current state is not A (y[0]) and not D (y[3])
    // 2. Input w is 0
    // Using AND gates for better PPA (power and area)
    assign Y3 = ~w & ~y[0] & ~y[3];

endmodule