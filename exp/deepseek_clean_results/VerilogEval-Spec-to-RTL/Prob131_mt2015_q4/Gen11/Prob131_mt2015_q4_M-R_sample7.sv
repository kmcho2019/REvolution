module TopModule(
    input x,
    input y,
    output z
);
    // Combined logic from both ModuleA and ModuleB instances
    // Original structure: (A1_out OR B1_out) XOR (A2_out AND B2_out)
    // Where all modules receive same x,y inputs
    // A_out = x & ~y
    // B_out = ~(x ^ y)
    
    // Final output calculation:
    // z = ((A1_out | B1_out) ^ (A2_out & B2_out))
    // Since all modules have same inputs, we can simplify to:
    assign z = ((x & ~y) | ~(x ^ y)) ^ ((x & ~y) & ~(x ^ y));
endmodule