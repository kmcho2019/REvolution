// Module A
module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B
module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x & y);
endmodule

// Top-level module
module top_module(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Instantiate Module A and Module B
    A a1(x, y, a1_out);
    B b1(x, y, b1_out);
    A a2(x, y, a2_out);
    B b2(x, y, b2_out);

    // Connect outputs to OR and AND gates
    or or1(a1_out, b1_out, or_out);
    and and1(a2_out, b2_out, and_out);

    // Connect outputs of OR and AND to XOR
    xor xor1(or_out, and_out, z);
endmodule