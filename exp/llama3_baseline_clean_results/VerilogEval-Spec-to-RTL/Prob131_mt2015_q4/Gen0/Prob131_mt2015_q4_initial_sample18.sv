module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    A a1_mod(x, y, a1);
    A a2_mod(x, y, a2);
    B b1_mod(x, y, b1);
    B b2_mod(x, y, b2);

    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);
    xor xor1(or_out, and_out, z);
endmodule

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