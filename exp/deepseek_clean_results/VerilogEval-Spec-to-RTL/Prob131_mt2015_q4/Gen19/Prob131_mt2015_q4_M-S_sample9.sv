module TopModule(
    input x,
    input y,
    output z
);
    // Module A implementation: z = (x^y) & x = x & ~y
    wire module_a_out = x & ~y;
    
    // Module B implementation: from waveform analysis, z = ~(x ^ y)
    wire module_b_out = ~(x ^ y);
    
    // First pair (A and B) connected to OR
    wire or_out = module_a_out | module_b_out;
    
    // Second pair (A and B) connected to AND
    wire and_out = module_a_out & module_b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule