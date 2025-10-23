module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1] (B)
    output Y3       // Next state for y[3] (D)
);

    // Y1 remains simple: transition from A to B when w=1
    assign Y1 = y[0] & w;

    // Innovative Y3 implementation using priority encoding:
    // D is target when w=0 and in any state except A (y[0]) or D (y[3])
    // We check if any of bits [2:1] or [5:4] are set (states B,C,E,F)
    assign Y3 = ~w & (|y[2:1] | |y[5:4]);

    /* State Transition Explanation:
       The priority-encoded approach works because:
       - When w=0, we only need to know if we're NOT in A or D
       - The OR reduction (|) efficiently checks multiple bits
       - This matches all cases where we transition to D:
         B->D (y[1]), C->D (y[2]), E->D (y[4]), F->D (y[5])
       - Excludes A->A (y[0]) and D->A (y[3]) cases
    */
endmodule