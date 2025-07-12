module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = y;
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    A A1(x, y, a1_out);
    B B1(x, y, b1_out);
    A A2(x, y, a2_out);
    B B2(x, y, b2_out);

    or or1(a1_out, b1_out, or_out);
    and and1(a2_out, b2_out, and_out);

    xor xor1(or_out, and_out, z);
endmodule