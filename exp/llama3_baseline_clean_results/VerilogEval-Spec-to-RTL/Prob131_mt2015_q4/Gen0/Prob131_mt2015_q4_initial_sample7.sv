// Define Module A
module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Define Module B
module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

// Define the top-level module
module top(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out;
    
    // Instantiate the A and B submodules
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);
    
    // Connect the outputs to the OR and AND gates
    wire or_out, and_out;
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);
    
    // Connect the OR and AND outputs to the XOR gate
    xor xor_gate(or_out, and_out, z);
endmodule