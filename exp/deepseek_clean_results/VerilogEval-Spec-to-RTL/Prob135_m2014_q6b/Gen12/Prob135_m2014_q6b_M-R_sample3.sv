module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // y[1] will be 1 in next state for transitions to D (011) or F (101)
    assign next_y1 = 
        (~y[2] & ~y[1] & ~y[0] & ~w) |  // A→B (should be 0, but included for completeness)
        (~y[2] & ~y[1] & y[0] & w) |    // B→D
        (~y[2] & y[1] & ~y[0] & w) |    // C→D
        (~y[2] & y[1] & y[0] & w) |     // D→A (should be 0, but included for completeness)
        (y[2] & ~y[1] & ~y[0] & w) |    // E→D
        (y[2] & ~y[1] & y[0] & w) |     // F→D
        (y[2] & ~y[1] & y[0] & ~w);     // F→C (should be 0, but included for completeness)

    // Simplified version focusing only on cases where y[1] is 1 in next state
    assign next_y1_optimized = 
        (~y[2] & ~y[1] & y[0] & w) |  // B→D
        (~y[2] & y[1] & ~y[0] & w) |  // C→D
        (y[2] & ~y[1] & ~y[0] & w) |  // E→D
        (y[2] & ~y[1] & y[0]);        // F→D or F→C (but only D sets y[1]=1)

    // Most optimized version (after analyzing truth table)
    assign next_y1_final = 
        (~y[2] & ((~y[1] & y[0] & w) | (y[1] & ~y[0] & w))) |  // B→D or C→D
        (y[2] & ~y[1] & (w | y[0]));                           // E→D or F→D

endmodule