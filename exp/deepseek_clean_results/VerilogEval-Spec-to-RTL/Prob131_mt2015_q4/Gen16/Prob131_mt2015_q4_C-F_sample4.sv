module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA equivalent: z = (x^y) & x = x & ~y
    wire a_out = x & ~y;
    
    // Compute ModuleB equivalent: truth table matches XNOR
    wire b_out = ~(x ^ y);
    
    // Final output optimized to XOR of intermediate results
    assign z = a_out ^ b_out;
endmodule