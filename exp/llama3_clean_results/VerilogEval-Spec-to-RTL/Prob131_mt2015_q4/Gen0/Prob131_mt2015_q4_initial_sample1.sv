module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = x & y;
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    A u_a1(x, y, a1);
    B u_b1(x, y, b1);
    A u_a2(x, y, a2);
    B u_b2(x, y, b2);

    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);
    xor xor1(or_out, and_out, z);
endmodule