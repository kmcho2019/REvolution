module TopModule (
    input [5:0] y,  // Current state in one-hot (A=y[0], B=y[1],... F=y[5])
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state D)
);

    // Next state B (Y2) occurs only when in state A and w=0 (A->B)
    assign Y2 = y[0] & ~w;

    // Next state D (Y4) occurs when:
    // 1. In state B and w=1 (B->D)
    // 2. In state C and w=1 (C->D)
    // 3. In state E and w=1 (E->D)
    // 4. In state F and w=1 (F->D)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule