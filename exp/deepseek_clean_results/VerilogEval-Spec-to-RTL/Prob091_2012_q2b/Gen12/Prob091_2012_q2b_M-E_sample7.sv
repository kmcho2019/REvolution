module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Only active when in state A and w=1
    // No need to check other states due to one-hot property
    assign Y1 = y[0] & w;

    // Y3: Active for transitions to D (state y[3])
    // Cases:
    // 1. From B or C with w=0
    // 2. From E or F with w=0
    // 3. From A with w=0 (but not when staying in A)
    // Simplified using priority: if in E/F, those have precedence
    assign Y3 = ~w & (
                (y[1] | y[2] | y[4] | y[5]) |  // From B,C,E,F
                (y[0] & ~w)                     // From A with w=0
               );

endmodule