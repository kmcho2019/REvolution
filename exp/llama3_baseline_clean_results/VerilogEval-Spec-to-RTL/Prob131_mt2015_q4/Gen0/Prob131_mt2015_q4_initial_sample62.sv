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
    assign z = (x == y); // Equality function
endmodule

// Define the top-level module
module top(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Instantiate Module A and Module B
    A a1(x, y, a1_out);
    A a2(x, y, a2_out);
    B b1(x, y, b1_out);
    B b2(x, y, b2_out);

    // Connect outputs to OR and AND gates
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);

    // Final XOR gate
    xor xor_gate(or_out, and_out, z);
endmodule

// Define OR, AND, and XOR gates as they are not built-in
module or(a, b, z);
    input a, b;
    output z;
    assign z = a | b;
endmodule

module and(a, b, z);
    input a, b;
    output z;
    assign z = a & b;
endmodule

module xor(a, b, z);
    input a, b;
    output z;
    assign z = a ^ b;
endmodule