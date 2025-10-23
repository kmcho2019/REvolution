module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2 is active when:
    // 1. In state A (y[0]) and w=0 (transition to B)
    // 2. In state F (y[5]) and w=0 (transition to C)
    assign Y2 = (~w & y[0]) | (~w & y[5]);

    // Y4 is active when:
    // 1. In state B (y[1]) and w=1 (transition to D)
    // 2. In state C (y[2]) and w=1 (transition to D)
    // 3. In state D (y[3]) and w=1 (transition to A)
    // 4. In state E (y[4]) and w=1 (transition to D)
    // 5. In state F (y[5]) and w=1 (transition to D)
    assign Y4 = (w & y[1]) | (w & y[2]) | (w & y[3]) | (w & y[4]) | (w & y[5]);

endmodule