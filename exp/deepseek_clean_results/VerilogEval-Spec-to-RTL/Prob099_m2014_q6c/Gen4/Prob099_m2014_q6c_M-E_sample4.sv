module TopModule (
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Next state Y2 (B/y[1]) logic:
    // Only active when current state is A (y[0]) and w=0
    assign Y2 = y[0] & ~w;

    // Next state Y4 (D/y[3]) logic:
    // Active when:
    // 1. Current state is B (y[1]) and w=1
    // 2. Current state is C (y[2]) and w=1
    // 3. Current state is D (y[3]) and w=1 (but D can't transition to itself)
    // 4. Current state is E (y[4]) and w=1
    // 5. Current state is F (y[5]) and w=1
    assign Y4 = (y[1] & w) |  // B->D when w=1
                (y[2] & w) |  // C->D when w=1
                (y[4] & w) |  // E->D when w=1
                (y[5] & w);   // F->D when w=1

endmodule