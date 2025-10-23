module TopModule(
    input [5:0] y,  // Current state
    input w,        // Input
    output Y1,      // Next state signal for y[1] (state B)
    output Y3       // Next state signal for y[3] (state D)
);

    // Deriving next-state logic by inspection for Y1 (state B)
    // Y1 is 1 when the next state should be B, which happens from A when w=1
    assign Y1 = (y[0] && w);  // Transition from A to B when w is 1

    // Deriving next-state logic by inspection for Y3 (state D)
    // Y3 is 1 when the next state should be D, which can happen from B, C, or E when w=1
    assign Y3 = ((y[1] || y[2] || y[4]) && w);  // Transition to D from B, C, or E when w is 1

endmodule