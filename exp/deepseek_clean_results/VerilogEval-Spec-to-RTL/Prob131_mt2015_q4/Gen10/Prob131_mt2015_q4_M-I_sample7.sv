module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of the combined logic
    // ModuleA: z = (x ^ y) & x = x & ~y
    // ModuleB: z = ~(x ^ y) = x == y
    // Final logic: z = (a1_out | b1_out) ^ (a2_out & b2_out)
    
    // Simplified expressions:
    wire a1_out = x & ~y;          // ModuleA output
    wire b1_out = ~(x ^ y);        // ModuleB output
    wire or_out = a1_out | b1_out; // First OR result
    
    // Since a2_out and b2_out are same as a1_out and b1_out,
    // we can reuse the same signals
    wire and_out = a1_out & b1_out; // Second AND result
    
    assign z = or_out ^ and_out;   // Final XOR
    
    // Further simplification possible:
    // or_out = (x&~y) | ~(x^y) = ~y | ~(x^y) = ~(y & (x^y)) = ~(x & y)
    // and_out = (x&~y) & ~(x^y) = x&~y & (x==y) = x&~y & (x&y | ~x&~y) = x&~y & ~x&~y = 0
    // So z = ~(x&y) ^ 0 = ~(x&y)
    // Final ultra-optimized version:
    // assign z = ~(x & y);
endmodule