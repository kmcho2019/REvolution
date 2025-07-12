module TopModule(
    input x,
    input y,
    output z
);
    // Compute all fundamental 2-input boolean operations
    wire xy_and = x & y;
    wire xy_or = x | y;
    wire xy_xor = x ^ y;
    wire xy_nand = ~(x & y);
    wire xy_nor = ~(x | y);
    wire xy_xnor = ~(x ^ y);
    
    // Implement ModuleA function: (x^y) & x
    wire a_out = xy_xor & x;
    
    // Implement ModuleB function: waveform shows it's xnor
    wire b_out = xy_xnor;
    
    // Final optimized output
    assign z = a_out ^ b_out;
endmodule