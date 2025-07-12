module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA equivalent: z = (x^y) & x
    wire module_a_out = (x ^ y) & x;
    
    // Compute ModuleB equivalent: z = (~x & ~y) | (x & y)
    wire module_b_out = (x ~^ y);  // XNOR is equivalent to the ModuleB function
    
    // Combine outputs as specified
    wire or_result = module_a_out | module_b_out;
    wire and_result = module_a_out & module_b_out;
    
    // Final output
    assign z = or_result ^ and_result;
endmodule