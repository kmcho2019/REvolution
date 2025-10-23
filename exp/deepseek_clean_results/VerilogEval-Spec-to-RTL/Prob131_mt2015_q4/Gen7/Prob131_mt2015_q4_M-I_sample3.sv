module TopModule(
    input x,
    input y,
    output z
);
    // Compute all intermediate results directly
    wire a_out = (x ^ y) & x;       // ModuleA functionality
    wire b_out = (~x & ~y) | (x & y); // ModuleB functionality
    
    // Optimized final output calculation
    // (a_out | b_out) ^ (a_out & b_out) simplifies to ~(x ^ y)
    assign z = ~(x ^ y);
endmodule