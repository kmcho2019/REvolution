module TopModule(
    input x,
    input y,
    output z
);
    // Precompute shared terms once
    wire module_a_out = x & ~y;      // Original ModuleA function
    wire module_b_out = ~(x ^ y);    // Original ModuleB function
    
    // Instantiate outputs with hardwired select patterns
    wire out1 = module_a_out;        // U1: select = 0
    wire out2 = module_b_out;        // U2: select = 1
    wire out3 = module_a_out;        // U3: select = 0
    wire out4 = module_b_out;        // U4: select = 1
    
    // Optimized combined output expression
    assign z = (out1 | out2) ^ (out3 & out4);
    
    // Alternative: Further optimized expression
    // assign z = (module_a_out | module_b_out) ^ (module_a_out & module_b_out);
endmodule