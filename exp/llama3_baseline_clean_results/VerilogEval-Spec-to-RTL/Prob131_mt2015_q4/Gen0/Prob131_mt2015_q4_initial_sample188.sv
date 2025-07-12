module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module top_module(x, y, z);
    input x, y;
    output z;
    wire out_a1, out_b1, out_a2, out_b2, or_out, and_out;

    A a1(x, y, out_a1);
    B b1(x, y, out_b1);
    A a2(x, y, out_a2);
    B b2(x, y, out_b2);

    or or1(out_a1, out_b1, or_out);
    and and1(out_a2, out_b2, and_out);

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