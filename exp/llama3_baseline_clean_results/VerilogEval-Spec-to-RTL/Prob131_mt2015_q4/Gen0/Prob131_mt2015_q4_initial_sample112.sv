module top_level_module(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Module A implements z = (x^y) & x
    module_A a1(x, y, a1_out);
    module_A a2(x, y, a2_out);

    // Module B implements z = (x & y) | (!x & !y)
    module_B b1(x, y, b1_out);
    module_B b2(x, y, b2_out);

    // Connect outputs to OR and AND gates
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);

    // Final XOR gate to produce output z
    xor xor_gate(or_out, and_out, z);
endmodule

// Module A implementation
module module_A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B implementation
module module_B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

// Basic gate implementations for completeness
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