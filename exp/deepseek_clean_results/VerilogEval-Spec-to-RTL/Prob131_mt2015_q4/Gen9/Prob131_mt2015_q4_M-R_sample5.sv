module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA logic: z = (x^y) & x
    wire a_out = (x ^ y) & x;
    
    // Direct implementation of ModuleB logic: z = (~x & ~y) | (x & y)
    wire b_out = (~x & ~y) | (x & y);
    
    // Optimized final output
    assign z = a_out ^ b_out;
endmodule