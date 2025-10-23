module TopModule(
    input [5:0] y,  // One-hot encoding: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,
    output Y2,      // Next state B (y[1])
    output Y4       // Next state E (y[4])
);

    // Y2 is active when:
    // 1. In state A (y[0]) and w=0 (transition to B)
    assign Y2 = y[0] & ~w;

    // Y4 is active when:
    // 1. In state C (y[2]) and w=0 (transition to E)
    assign Y4 = y[2] & ~w;

endmodule