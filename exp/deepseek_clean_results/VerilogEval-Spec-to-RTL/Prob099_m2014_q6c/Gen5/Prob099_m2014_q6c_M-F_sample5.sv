module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state Y1 (A/y[0]) logic:
    // Active when:
    // 1. Current state is A (y[0]) and w=1 (A->A)
    // 2. Current state is D (y[3]) and w=1 (D->A)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Next state Y3 (D/y[3]) logic:
    // Active when:
    // 1. Current state is B (y[1]) and w=1 (B->D)
    // 2. Current state is C (y[2]) and w=1 (C->D)
    // 3. Current state is E (y[4]) and w=1 (E->D)
    // 4. Current state is F (y[5]) and w=1 (F->D)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule