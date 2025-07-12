module TopModule(
    input [5:0] y,  // One-hot encoded current state
    input w,        // Input signal
    output Y2,      // Next state y[1] (B)
    output Y4       // Next state y[3] (D)
);

    // Next state logic for Y2 (B)
    // B can be reached from:
    // 1. A when w=0 (A->B)
    assign Y2 = y[0] & ~w;

    // Next state logic for Y4 (D)
    // D can be reached from:
    // 1. B when w=1 (B->D)
    // 2. C when w=1 (C->D)
    // 3. E when w=1 (E->D)
    // 4. F when w=1 (F->D)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule