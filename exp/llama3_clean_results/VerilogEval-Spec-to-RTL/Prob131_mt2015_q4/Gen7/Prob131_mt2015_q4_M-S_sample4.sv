module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Direct implementation of ModuleA's logic
    wire a1_out = (x ^ y) & x;
    wire a2_out = (x ^ y) & x;
    
    // Simplified implementation of ModuleB's logic based on the simulation waveform
    wire b1_out = ~(x ^ y);
    wire b2_out = ~(x ^ y);
    
    // Combine outputs of ModuleA and ModuleB instances
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output through XOR gate
    assign z = or_out ^ and_out;
endmodule