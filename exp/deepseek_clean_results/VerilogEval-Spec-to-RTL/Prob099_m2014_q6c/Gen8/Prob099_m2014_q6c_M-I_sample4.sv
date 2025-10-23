module TopModule(
    input [5:0] y,  // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,
    output Y1,      // next y[0] (state A)
    output Y3       // next y[3] (state D)
);

    // Y1: Next state A (y[0])
    // Active when:
    // 1. Current state A (y[0]) and w=1 (stay in A)
    // 2. Current state D (y[3]) and w=1 (transition to A)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y3: Next state D (y[3])
    // Active when:
    // 1. Current state B (y[1]) and w=1 (transition to D)
    // 2. Current state C (y[2]) and w=1 (transition to D)
    // 3. Current state E (y[4]) and w=1 (transition to D)
    // 4. Current state F (y[5]) and w=1 (transition to D)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule