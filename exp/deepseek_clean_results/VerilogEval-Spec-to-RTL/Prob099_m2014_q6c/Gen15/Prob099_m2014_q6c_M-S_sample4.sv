module TopModule (
    input [5:0] y,  // Current state (A=y[0], B=y[1], ..., F=y[5])
    input w,        // Input signal
    output Y1,      // Next state y[1] (B)
    output Y3       // Next state y[3] (D)
);

    // Y1 (next state B) comes from:
    // 1. A->B when w=0 (y[0] & ~w)
    assign Y1 = y[0] & ~w;

    // Y3 (next state D) comes from:
    // 1. B->D when w=1 (y[1] & w)
    // 2. C->D when w=1 (y[2] & w)
    // 3. E->D when w=1 (y[4] & w)
    // 4. F->D when w=1 (y[5] & w)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule