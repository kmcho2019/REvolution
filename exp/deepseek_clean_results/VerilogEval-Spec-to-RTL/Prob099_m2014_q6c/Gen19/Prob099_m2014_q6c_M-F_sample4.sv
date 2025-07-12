module TopModule (
    input [5:0] y,  // Current state in one-hot (A=y[0], B=y[1],... F=y[5])
    input w,        // Input signal
    output Y1,      // Next state y[0] (state A)
    output Y3       // Next state y[2] (state C)
);

    // Next state A (Y1) occurs when:
    // 1. In state A and w=1 (A->A)
    // 2. In state D and w=1 (D->A)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Next state C (Y3) occurs when:
    // 1. In state B and w=0 (B->C)
    // 2. In state F and w=0 (F->C)
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule