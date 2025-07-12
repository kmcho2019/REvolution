// Module A implements the boolean function z = (x^y) & x
module module_a(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B's behavior is described by the given simulation waveform
// It can be observed that z = ~(x ^ y)
module module_b(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

// Top-level module
module top_level(x, y, z);
    input x, y;
    output z;
    
    // Instantiate submodules
    wire a1_out, b1_out, a2_out, b2_out;
    
    module_a a1(x, y, a1_out);
    module_b b1(x, y, b1_out);
    module_a a2(x, y, a2_out);
    module_b b2(x, y, b2_out);
    
    // Connect outputs to OR and AND gates
    wire or_out, and_out;
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);
    
    // Compute final output 'z' using XOR
    xor xor_gate(or_out, and_out, z);
endmodule