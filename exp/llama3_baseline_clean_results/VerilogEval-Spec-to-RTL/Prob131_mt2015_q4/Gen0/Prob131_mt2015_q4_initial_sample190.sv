// Module A implementation
module module_a(x, y, z);
    input x;
    input y;
    output z;

    assign z = (x ^ y) & x;
endmodule

// Module B implementation
module module_b(x, y, z);
    input x;
    input y;
    output z;

    assign z = (x == y);
endmodule

// Top-level module implementation
module top_level(x, y, z);
    input x;
    input y;
    output z;

    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    module_a a1(x, y, a1_out);
    module_b b1(x, y, b1_out);
    module_a a2(x, y, a2_out);
    module_b b2(x, y, b2_out);

    or or1(a1_out, b1_out, or_out);
    and and1(a2_out, b2_out, and_out);

    xor xor1(or_out, and_out, z);
endmodule

// Basic gates implementation
module or(a, b, z);
    input a;
    input b;
    output z;

    assign z = a | b;
endmodule

module and(a, b, z);
    input a;
    input b;
    output z;

    assign z = a & b;
endmodule

module xor(a, b, z);
    input a;
    input b;
    output z;

    assign z = a ^ b;
endmodule