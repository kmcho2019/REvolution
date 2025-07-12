module TopModule (
    input [5:0] y,  // Current state in one-hot (A=y[0], B=y[1],... F=y[5])
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state E)
);

    // Next state B (Y2) occurs only when in state A and w=0
    assign Y2 = y[0] & ~w;

    // Next state E (Y4) occurs when:
    // 1. In state C and w=0 (C->E)
    // 2. In state E and w=0 (E->E)
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule