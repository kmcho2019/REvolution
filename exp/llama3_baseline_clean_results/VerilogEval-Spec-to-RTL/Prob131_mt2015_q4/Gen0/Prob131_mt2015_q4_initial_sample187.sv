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
    wire z_A1, z_B1, z_A2, z_B2, or_out, and_out;

    A A1(x, y, z_A1);
    B B1(x, y, z_B1);
    A A2(x, y, z_A2);
    B B2(x, y, z_B2);

    or or1(z_A1, z_B1, or_out);
    and and1(z_A2, z_B2, and_out);

    xor xor1(or_out, and_out, z);
endmodule