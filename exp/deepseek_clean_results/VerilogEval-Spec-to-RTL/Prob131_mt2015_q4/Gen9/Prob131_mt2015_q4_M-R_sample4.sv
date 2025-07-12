module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA's logic: z = (x^y) & x
    wire a_out = (x ^ y) & x;
    
    // Direct implementation of ModuleB's logic: z = (~x & ~y) | (x & y)
    wire b_out = (~x & ~y) | (x & y);
    
    // Optimized XOR implementation
    assign z = (a_out & ~b_out) | (~a_out & b_out);
endmodule