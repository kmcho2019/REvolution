// Module A implements the boolean function z = (x^y) & x
module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B implements the boolean function z = x & y
module B(x, y, z);
    input x, y;
    output z;
    assign z = x & y;
endmodule

// Top-level module
module top(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    // Instantiate Module A and Module B
    A a1_mod(x, y, a1);
    A a2_mod(x, y, a2);
    B b1_mod(x, y, b1);
    B b2_mod(x, y, b2);
    
    // Connect outputs to OR and AND gates
    or or_gate(a1, b1, or_out);
    and and_gate(a2, b2, and_out);
    
    // Connect outputs of OR and AND gates to XOR gate
    xor xor_gate(or_out, and_out, z);
endmodule