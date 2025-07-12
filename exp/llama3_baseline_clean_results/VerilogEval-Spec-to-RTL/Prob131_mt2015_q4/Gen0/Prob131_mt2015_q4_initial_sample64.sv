// Module A implementation
module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B implementation
module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x & ~y);
endmodule

// Top-level module
module top_level(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    // Instantiate modules
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);

    // Connect outputs to OR and AND gates
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);

    // Connect OR and AND outputs to XOR gate
    xor xor_gate(or_out, and_out, z);
endmodule