module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // Y1 is active when:
    // 1. In state D (y[3]) and w=1 (transition to A)
    assign Y1 = w & y[3];

    // Y3 is active when:
    // 1. In state B (y[1]) and w=0 (transition to C)
    // 2. In state F (y[5]) and w=0 (transition to C)
    assign Y3 = (~w & y[1]) | (~w & y[5]);

endmodule