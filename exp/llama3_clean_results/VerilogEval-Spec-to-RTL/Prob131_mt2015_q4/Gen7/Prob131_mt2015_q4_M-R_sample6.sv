module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the logic for ModuleA and ModuleB
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;
    assign b1_out = ~(x ^ y);
    assign b2_out = ~(x ^ y);
    
    // Combine the outputs of ModuleA and ModuleB submodules
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    
    // Final output is the XOR of the OR and AND outputs
    assign z = or_out ^ and_out;
endmodule