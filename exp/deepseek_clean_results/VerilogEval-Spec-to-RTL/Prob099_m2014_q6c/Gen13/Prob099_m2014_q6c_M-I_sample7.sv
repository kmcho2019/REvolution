module TopModule(
    input [5:0] y,  // One-hot encoding: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,
    output Y1,      // Next state B (y[1])
    output Y3       // Next state D (y[3])
);

    // Y1 is active when:
    // 1. In state A (y[0]) and w=0 (transition to B)
    assign Y1 = y[0] & ~w;

    // Y3 is active when:
    // 1. In state B (y[1]) and w=1 (transition to D)
    // 2. In state C (y[2]) and w=1 (transition to D)
    // 3. In state D (y[3]) and w=1 (transition to A, but A is y[0], not D)
    // 4. In state E (y[4]) and w=1 (transition to D)
    // 5. In state F (y[5]) and w=1 (transition to D)
    // Correction: Only states B, C, E, and F can transition to D with w=1
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule