// Module A: implements z = (x^y) & x
module A(x, y, z);
    input x, y;
    output z;
    assign z = ((x ^ y) & x);
endmodule

// Module B: based on the given simulation waveform
module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

// Top-level module
module top(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    // Instantiate A and B submodules
    A a1_mod(x, y, a1);
    A a2_mod(x, y, a2);
    B b1_mod(x, y, b1);
    B b2_mod(x, y, b2);
    
    // Connect outputs to OR and AND gates
    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);
    
    // Connect OR and AND outputs to XOR gate
    xor xor1(or_out, and_out, z);
endmodule