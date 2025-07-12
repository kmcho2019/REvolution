module TopModule(
    input x,
    input y,
    output z
);
    // Shared computation units
    wire a_out = (x ^ y) & x;  // Module A function
    wire b_out = ~(x ^ y);     // Module B function (XNOR)
    
    // Smart output selection
    // Original logic: z = ((a1_out | b1_out) ^ (a2_out & b2_out))
    // Optimized equivalent: z = (a_out | b_out) ^ (a_out & b_out)
    // Which simplifies to: z = a_out ^ b_out
    assign z = a_out ^ b_out;
    
    /* Truth Table Verification:
    x y | a_out b_out | z
    -----|------------|---
    0 0 |   0     1   | 1
    0 1 |   0     0   | 0
    1 0 |   1     0   | 1
    1 1 |   0     1   | 1
    Matches required behavior
    */
endmodule